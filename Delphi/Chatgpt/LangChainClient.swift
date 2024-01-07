//
//  LangChainClient.swift
//  Delphi
//
//  Created by Kelsey Larson on 10/31/23.
//class == reference, struct == copies created

import Foundation
import UIKit
import NIO
import SwiftUI
import LangChain
import AsyncHTTPClient
import PineconeSwift

class LangChainClient: ObservableObject {
   var vectorManagement = LangChainManagement() //index calculations
   
   //talks to pinecone index via vectorManagement.
   func createTemplate(context: String) async -> String {
    //    vectorManagement.PopulateIndex() //make sure our index is populated. test this with real device later
        let indexContext = await vectorManagement.queryIndex(newQuery: context)
        var templateString = ""
        if let indexString = indexContext.data(using: .utf8) {
           do {
               if let json = try JSONSerialization.jsonObject(with: indexString, options: []) as? [String: Any],
                  let stringValue = json["text"] as? String {
                   // print("SUCCESS")
                    //print(stringValue)
                    templateString = stringValue
               }
           } catch {
               print("Error parsing JSON: \(error)")
           }
        }
        
        let template =
       /*
        """
           You are an expert in the field of dream analysis and interpretation. You strive to give the user understanding on the dream in their concious life, and also understanding of their unconcious minds choices. Your goal is to help deepen someones understanding in the way they think and function, through the understanding of their dreams. Use the dream that is described to help the user. Allow the conversation to flow. If the users describes more of the dream, continue to dive into it. If they ask general questions, allow the conversation to detour towards that direction and use less dream information. Be sure to not stop your response in the middle of a sentence. The following information is relative to their inquiry and must be used in your response.Find a way to use the information in your answer. Make sure to break down this information in less academic terms.Adopt a tone of a casual conversation.If it makes sense, quote the information directly and relate it to the inquiry. \(templateString)
        """*/
       """
           You are an expert in the field of dream analysis and interpretation. Your goal is to provide understanding and insights into the dreams of the users. If the user's inquiry is about a dream, you MUST use the info provided below to help them. Use direct quotes from the information below to help them understand WHY these dreams happen. It is very important to use the data attached. Allow the conversation to flow naturally, diving deeper into the dream if the user provides more details. If the user asks general questions, you can explore those topics as well, using less dream information.

           When responding, adopt a casual tone of conversation and avoid using overly academic language. If it makes sense, you can directly quote the information related to the user's inquiry and relate it to their question.

           Remember to provide helpful interpretations and explanations to deepen the user's understanding of their dreams and themselves.
           Here is relevant data to supplement the response:
           \(templateString)
       """
        print(template)
///       If possible, ask questions to the user that may clarify if your analysis is correct
        return template
    }
    
    //TODO: change this to modify template based on results of langchain query
    //this will be used instead of openAiClient request if it proves not satisfactory
    /*func performOperations(userMessage: String, previousMessages: [String]) //need to add a completion handler here to return result to inputVM
    {
        
        let template =
        """
           You are an expert at the field of dream analysis and interpretation. You strive to give the user understanding on the dream in their concious life, and also understanding of their unconcious minds choices. Your goal is to help deepen someones understanding in the way they think and function, through the understanding of their dreams. Use the dream that is described to help the user. Use previous components of the conversation to modify the conversation as it flows. {human_input} {history}"
        """
        _ = PromptTemplate(input_variables: ["history", "human_input"],
                                    partial_variable: [:],
                                    template: template)
        //        Vectorize()
    }*/
}




    //if let url = Bundle.main.url(forResource: "FreudDreams", withExtension: "pdf") {
//        if let url = Bundle.main.url(forResource: "Jungtest", withExtension: "pdf") {
        //    let pdf = PDFLoader(fileURL: url)
    //Load the document and split into chunks (PDF OR TEXT????)
    /* func loadFile() -> [Document] {
     let fileURL = Bundle.main.url(forResource: "JungTest2", withExtension: "txt")
     let filePath = fileURL?.path ?? ""
     let textLoader = TextLoader(file_path: filePath)
     Task {
     do {
     let documents = try await textLoader._load()
     print(documents)
     return documents
     } catch {
     print("Failed to load text: \(error)")
     }
     }
     }*/

/*var body: some View {
        VStack {
            Text(output)
                .padding()
                .onAppear {
                    performOperations(userMessage: "Hi there", previousMessages: [""])
                }
        }
    }
    
    @State private var output: String = ""
*/
    
/*
struct langViewtest: View {
    
    var body: some View {
        NavigationView {
          LangChainClient()
        }
    }
}*/
//struct LangChainClient: View {
    //    static let shared = LangChainClient() //singleton instance for lifespan
 /*
    func Vectorize () {
        Task {
            //move the task of creating vectors, embeddings, to vector management
            let documentString = ModifyFile(filePath: "Jungtextlonger.txt")
            let textSplitter = CharacterTextSplitter(chunk_size: 2000, chunk_overlap: 400)
            let splitText  = textSplitter.split_text(text: documentString)
            print("chunk count", splitText.count)
            var embeddings = OpenAIEmbeddings() //uses Ada
            var i = 0
            var embeddingList = [EmbedResult]()
            
            for chunk in splitText {
                let vector = await embeddings.embedQuery(text: chunk)
                let vectorConform = vector.map { Double($0) }
                let embed = EmbedResult(index: i, embedding: vectorConform, text: chunk)
                i += 1
                embeddingList.append(embed)
                print("resulting vector 🌈:", vector)
            }
            
            do {
              try embeddings.shutdown()
            } catch {
                print("shutdown http failed")
            }
            //TODO: figure out how to send message in multiple calls. just splitting in half for now.
            let halfIndex = embeddingList.count/4
            let halvedEmbeddingList = Array(embeddingList[..<halfIndex])
            vectorManagement.upsertEmbeddings(embeddings: halvedEmbeddingList)
            //vectorManagement.createEmbeddings(embeddings: embeddingList)
        }
    }
   
    //retrieve and conform data to prep for pinecone upsert
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
    }*/
