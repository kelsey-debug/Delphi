//
//  InputViewModel.swift
//  Delphi
//
//  Created by Kelsey Larson on 9/20/23.
//

import Foundation
import Combine

//separate class from swiftUI, therefore does not have automatic init. needs maanual init
class InputViewModel: ObservableObject {
    //published so changes to data are observed in corresponding view
    @Published var newMessage = ""
    @Published var placeHolderMessage = ""
    @Published var chatMessages: [chatMessage] = chatMessage.testMessages //for test purposes
    let client: AIClient
    
    init(client: AIClient) {
        self.client = client
    }
    
    var id = UUID() 
    
    func sendMessage() async {
        if !newMessage.isEmpty {
            let newChat = chatMessage(id: UUID().uuidString,
                                      content: newMessage,
                                      dateCreated: Date(),
                                      sender: .user)
            chatMessages.append(newChat)
            // make async call to openAI
           /* await client.request(userMessage: newMessage) { result in
                switch result {
                case .success(let completion):
                    let gptResponse = String(describing: completion.choices[0].message)
                    let newChat = chatMessage(id: UUID().uuidString, content: gptResponse, dateCreated: Date(), sender: .gpt)
                    chatMessages.append(newChat)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }*/
        }
    }
}
