//
//  UserData.swift
//  Delphi
//
//  Created by Kelsey Larson on 10/25/23.
//

import Foundation
import PineconeSwift
import LangChain

class SharedUserData: ObservableObject {
    
    var userStorage = UserStorage.shared
    let client = AIClient.shared
    @Published var chatsList: [InputViewModel] = []
 
    var pinecone = PineconeSwift(apikey: Enviroment.pineconeKey,
                                 baseURL: Enviroment.pineconebaseURL)
    
    func retrieveFiles() -> [String] {
      let trainingData = ["FreudDreams.txt","Jungtextlonger.txt"]
      return trainingData
    }
    
    func saveUserData() {
        var temp = [[chatMessage]]()
        for viewModel in chatsList {
            let msgs = viewModel.chatMessages
            temp.append(msgs)
        }
        userStorage.saveChatMessage(chatMessages: temp)
    }
    
    func fetchUserData() {
        var fetchedVM = [InputViewModel]()
        let chatData = userStorage.getChatMessages()
        for chat in chatData { // so chat = [ChatMessage]
            let inputVM = InputViewModel(client: client, chatMessages: chat)
            fetchedVM.append(inputVM)
        }
        chatsList = fetchedVM
    }

    //to be called at APP level when needed to update vectors.
    func PopulateIndex() async {
        let value = userStorage.defaults.object(forKey: "lastExecutionDate")
        if value == nil {
            await upsertEmbeddings() //run for the first time
        } else {
            if let lastExecutionDate = userStorage.defaults.object(forKey: "lastExecutionDate") as? Date {
                let thirtyDays: TimeInterval = 30 * 24 * 60 * 60
                let currentDate = Date()
                
                // Check if 30 days have passed since the last execution
                if currentDate.timeIntervalSince(lastExecutionDate) >= thirtyDays {
                    await upsertEmbeddings()
                    userStorage.defaults.set(currentDate, forKey: "lastExecutionDate")
                }
            }
        }
    }
    
    func upsertEmbeddings() async {
        let dreamFiles = retrieveFiles()
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
                  //  print("resulting vector 🌈:", vector)
                }
                embeddingTech.shutdown() //must be called OUTSIDE embedquery as we are waiting for future response
                
           //     let halfIndex = embeddingList.count/4
            //    let halvedEmbeddingList = Array(embeddingList[..<halfIndex])
                //loop through the whole list and upsert each time
                for embedding in embeddingList {
                    do {
                        let result = try await pinecone.upsertVectors(with: [embedding], namespace: "")
                        print("RESULT OF UPSERT: ", result)
                    }catch {
                        print("pinecone upsert failed",error)
                    }
                }
            }
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
}
