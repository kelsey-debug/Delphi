//
//  InputViewModel.swift
//  Delphi
//
//  Created by Kelsey Larson on 9/20/23.
//

import Foundation
import Combine

//separate class from swiftUI, therefore does not have automatic init. needs manual init
class InputViewModel: ObservableObject {
    @Published var newMessage = ""
    @Published var placeHolderMessage = ""
    @Published var chatMessages = [chatMessage]()
    
    var VMid = UUID() //to distinguish between conversations/inputviewmodel instances
    var prevMsgs = [String]()
    let client: AIClient
    var langChainClient: LangChainClient
    
    init(client: AIClient, chatMessages: [chatMessage]?) {
      self.client = client
      self.langChainClient = LangChainClient()
      if let messages = chatMessages { //if its not nil, assign it to the current vm
        self.chatMessages = messages
      }
    }

    func sendMessage() async {
        if !newMessage.isEmpty {
            let newChat = chatMessage(id: UUID(),
                                      content: newMessage,
                                      dateCreated: Date(),
                                      sender: "user")
            DispatchQueue.main.async { [self] in
                chatMessages.append(newChat)
                prevMsgs.append(newMessage)
            }
            let sysMsg = await langChainClient.createTemplate(context: newMessage)
            await client.request(userMessage: newMessage,
                                 systemMessage: sysMsg,
                                 previousMessages: prevMsgs) { result in
                switch result {
                case .success(let completion):
                    let gptResponse = String(describing: completion.choices[0].message.content)
                    let newChat = chatMessage(id: UUID(), content: gptResponse, dateCreated: Date(), sender: "gpt")
                    DispatchQueue.main.async { [self] in
                        chatMessages.append(newChat)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
