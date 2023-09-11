//
//  InputView.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/23/23.
//
//figure out how to parse string response
//I want it to return iteratively like on chatgpt
//user info page - email, birthday for horoscope, weather
//this will all be used for inquirys eventually.

import SwiftUI

struct InputView: View {
    @State private var newMessage = ""
    @State private var placeHolderMessage = ""
    @State private var chatMessages: [chatMessage] = chatMessage.testMessages
    @Binding var numbers: [InputView] //borrowed from contentview

    var id: UUID
    var client: AIClient

    init(numbers: Binding<[InputView]>) {
          _numbers = numbers
          id = UUID()
          client = AIClient()
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(chatMessages, id:  \.id) { message in
                        messageView(message: message)
                    }
                }
            }
            .padding()
            HStack {
              TextField("type here", text: $placeHolderMessage) {
                 Task {
                      newMessage = placeHolderMessage
                      placeHolderMessage = ""
                      await sendMessage()
                  }
               }
              .padding()
              .background(.gray.opacity(0.1))
              .cornerRadius(12)
//               .keyboardType(.default)
                Button {
                    Task {
                      newMessage = placeHolderMessage
                      placeHolderMessage = ""
                      await sendMessage()
                    }
                } label: {
                    Text("send")
                }
                .foregroundColor(.white)
                .padding()
                .background(.black)
                .cornerRadius(12)
               
            }
            .padding()
        }
        .onDisappear {
            DispatchQueue.main.async { //to update UI on main thread always
                    self.numbers.append(self)
            }
        }
    }
    
    //formats message based on type
    func messageView(message: chatMessage) -> some View {
        HStack { //spacers work bc of hstack organization
            if message.sender == .user {Spacer()}
            Text(message.content)
                .foregroundColor(message.sender == .user ? .white: .black)
                .padding()
                .background(message.sender == .user ? .blue: .gray.opacity(0.1))
                .cornerRadius(16)
            if message.sender == .gpt {Spacer()}
        }
    }
    
    func sendMessage() async {
        if !newMessage.isEmpty {
            let newChat = chatMessage(id: UUID().uuidString,
                                      content: newMessage,
                                      dateCreated: Date(),
                                      sender: .user)
            chatMessages.append(newChat)
            // make async call to openAI
         /*   await client.request(userMessage: newMessage) { result in
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

struct InputView_Previews: PreviewProvider {
    static var fake = [InputView]()

    static var previews: some View {
        InputView(numbers: .constant(fake))
    }
}

            
