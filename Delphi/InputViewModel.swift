//
//  InputViewModel.swift
//  Delphi
//
//  Created by Kelsey Larson on 9/20/23.
//

import Foundation
import Combine

//separate class from swiftUI, therefore does not have automatic init. needs manual init
//if im using userstorage here, what are the params for saving, and for fetching?
// saving -- 
class InputViewModel: ObservableObject {
    //published so changes to data are observed in corresponding view
    //these values are updated inside the view main thread in inputview.so I dont have an error
    @Published var newMessage = ""
    @Published var placeHolderMessage = ""
    @Published var chatMessages = [chatMessage]()
    
    var VMid = UUID() //to distinguish between conversations/inputviewmodel instances
    var prevMsgs = [String]()
    let client: AIClient
    
    init(client: AIClient, chatMessages: [chatMessage]?) { //optional init (?) for inputvm chatMessages data
      self.client = client
      if let messages = chatMessages { //if its not nil, assign it to the current vm
        self.chatMessages = messages
      }
    }
   
    ///*
    ///TODO: my chatmessages for ONE instance of an inputVM need to all be the same.
    /// They need to be distinguished between INSTANCES of inputVMs, not instances of ChatMessage */
    func sendMessage() async {
        if !newMessage.isEmpty {
            let newChat = chatMessage(id: UUID().uuidString,
                                      content: newMessage,
                                      dateCreated: Date(),
                                   //   sender: .user)
                                      sender: "user")
            DispatchQueue.main.async { [self] in //published swiftUI changes must be done on the main thread
                chatMessages.append(newChat)
                prevMsgs.append(newMessage)
            }
            //TODO: use langchain here!!
            // make async call to openAI
          /*  await client.request(userMessage: newMessage, previousMessages: prevMsgs) { result in
                switch result {
                case .success(let completion):
                    let gptResponse = String(describing: completion.choices[0].message)
                    let newChat = chatMessage(id: UUID().uuidString, content: gptResponse, dateCreated: Date(), sender: .gpt)
                    DispatchQueue.main.async { [self] in
                        chatMessages.append(newChat)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }*/
        }
    }
}
