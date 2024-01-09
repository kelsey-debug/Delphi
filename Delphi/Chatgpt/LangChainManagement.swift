//
//  Delphi
//
//Created by Kelsey Larson on 11/8/23.
//responsible for creating embeddings, vectors, and direct contain to LangChain index

import Foundation
import PineconeSwift
import LangChain

class LangChainManagement {
   
    var pinecone = PineconeSwift(apikey: Enviroment.pineconeKey,
                                 baseURL: Enviroment.pineconebaseURL)
   // var embeddingTech = OpenAIEmbeddings() //uses Ada //may be causing shutdown issue here
    var userStorage = UserStorage.shared
  
    //takes doc, creates embedding list, upserts
    //docstring -> vectors ->embeddings
    //TODO. put this in a loop to go through each source in TrainingData folder
    //format file into an array of strings, for each chunk create a vector. upsert into pinecone
    
    func retrieveFiles() -> [String] {
      let trainingData = ["FreudDreams.txt","Jungtextlonger.txt"]
      return trainingData
    }
    
    func upsertEmbeddings() {
        let dreamFiles = retrieveFiles()
    //  let dreamFiles = ["Jungtextlonger.txt"]
//      let embeddingTech = OpenAIEmbeddings() //here it will be shutdwon b4 next file
        Task {
            for file in dreamFiles {
                let embeddingTech = OpenAIEmbeddings()
                let documentString = ModifyFile(filePath: file)
                let textSplitter = CharacterTextSplitter(chunk_size: 2500, chunk_overlap: 400)
                let splitText  = textSplitter.split_text(text: documentString)
                
                var i = 0
                var embeddingList = [EmbedResult]()
                for chunk in splitText {
                    let vector = await embeddingTech.embedQuery(text: chunk)
                    let vectorConform = vector.map { Double($0) }
                    let embed = EmbedResult(index: i, embedding: vectorConform, text: chunk)
                    i += 1
                    embeddingList.append(embed)
                    print("resulting vector 🌈:", vector)
                }
                embeddingTech.shutdown() //must be called OUTSIDE embedquery!!
                //TODO: figure out how to send message in multiple calls. just splitting in half for now.
                //need nested loops to upsert entire embedding list
                let halfIndex = embeddingList.count/4
                let halvedEmbeddingList = Array(embeddingList[..<halfIndex])
                //   vectorManagement.upsertEmbeddings(embeddings: halvedEmbeddingList)
                let result = try await pinecone.upsertVectors(with: halvedEmbeddingList, namespace: "")
                print("RESULT OF UPSERT: ", result)
            }
        }
    }
  //create langchain embedding from string
    func queryIndex(newQuery: String) async -> String {
        var IndexData = ""
        var queryResult = [PineconeVector]()
        let embed = await createEmbeddings(Query: newQuery)
        do {
          queryResult = try await pinecone.queryVectors(with: embed,
                                                                namespace: "",
                                                                topK: 3,
                                                              includeMetadata: true)
        }
        catch {
         print(error)
        }
        IndexData = queryResult.first!.metadata.queryValue //only using 1 value here. need to return an array
        print("one of the resulting vectors from the new index query")
        return IndexData
    }
   
    //queryString -> embedding -> vector
    //for each query to be combined with result of queryindex, returned to client?
    func createEmbeddings (Query: String) async -> EmbedResult {
        let embeddingTech = OpenAIEmbeddings() //uses Ada //may be causing shutdown issue here
        let vector = await embeddingTech.embedQuery(text: Query)
      /*  do {
            try embeddingTech.shutdown()
        } catch {
            print("shutdown http failed")
        }*/
        embeddingTech.shutdown()
        let vectorConform = vector.map { Double($0) }
        let embed = EmbedResult(index: 1, embedding: vectorConform, text: Query)
     //   shutDownAda()
        return embed
    }
    
    func ModifyFile (filePath: String) -> String {
        let nameAndExt = filePath.split(separator: ".")
        let name = "\(nameAndExt[0])"
        let ext = "\(nameAndExt[1])"
        var moddedData = ""
        if let res = Bundle.main.path(forResource: name, ofType: ext) {
            do {
                let text = try String(contentsOfFile: res)
                moddedData = text.replacingOccurrences(of: "\n", with: "\n\n")
            } catch {
                print("cant retrieve string contents of file")
            }
        }else {
            print("file DNE")
        }
        return moddedData
    }
    
    func PopulateIndex() { //TODO: this is being called everytime. this needs to happen before inquiry sent
        // Check if the last execution date is stored in UserDefaults
        let value = userStorage.defaults.object(forKey: "lastExecutionDate")
        if value == nil {
            upsertEmbeddings() //run for the first time
        } else {
            if let lastExecutionDate = userStorage.defaults.object(forKey: "lastExecutionDate") as? Date {
                let thirtyDays: TimeInterval = 30 * 24 * 60 * 60
                let currentDate = Date()
                
                // Check if 30 days have passed since the last execution
                if currentDate.timeIntervalSince(lastExecutionDate) >= thirtyDays {
                    upsertEmbeddings()
                    userStorage.defaults.set(currentDate, forKey: "lastExecutionDate")
                }
            }
        }
    }
  
}


 /*   func shutDownAda() {
        do {
            try embeddingTech.shutdown()
        } catch {
            print("shutdown http failed")
        }
    }*/
    

    /*   let result = try await pinecone.upsertVectors(with: embeddings, namespace: "")
            print("RESULT OF UPSERT: ", result)
           
            //testing ability to query vectors
            let query = "what did Carl Jung say about the nature of dreams?"
            let vector = await embeddingTech.embedQuery(text: query)
            let vectorConform = vector.map { Double($0) }
            let embed = EmbedResult(index: 1, embedding: vectorConform, text: query)
            
            let queryResult = try await pinecone.queryVectors(with: embed,
                                                              namespace: "",
                                                              topK: 3,
                                                            includeMetadata: true)
            do {
              try embeddingTech.shutdown()
            } catch {
                print("shutdown http failed")
            }
            print("RESULT OF QUERY:", queryResult.first!.metadata)
          */
