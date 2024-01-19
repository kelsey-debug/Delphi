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
//make animation more smooth

import SwiftUI

struct InputView: View {
   
    @ObservedObject var inputViewModel: InputViewModel
    @Binding var chatsList: [InputViewModel] //list of existing chats
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color(uiColor: ThemeManager.shared.primaryColor)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                        ForEach(inputViewModel.chatMessages, id: \.id) { message in
                            messageView(message: message)
                            
                        }.rotationEffect(.degrees(180))
                }
                .rotationEffect(.degrees(180))
                .padding()
                
                HStack {
                TextField("type here", text: $inputViewModel.placeHolderMessage) {
                    Task {
                        inputViewModel.newMessage = inputViewModel.placeHolderMessage
                        inputViewModel.placeHolderMessage = ""
                        await inputViewModel.sendMessage()
                    }
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(12)
                Button {
                   Task {
                        inputViewModel.newMessage = inputViewModel.placeHolderMessage
                        inputViewModel.placeHolderMessage = ""
                        await inputViewModel.sendMessage()
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
        }
        .onDisappear {
            DispatchQueue.main.async {
                if !chatsList.contains(where:{$0.VMid == inputViewModel.VMid})
                {
                    self.chatsList.append(inputViewModel)
                }
            }
        }
    }
    
    //formats message based on type
    func messageView(message: chatMessage) -> some View {
       let messageBubble = HStack { //spacers work bc of hstack organization
            if message.sender == "user" {Spacer()}
            Text(message.content)
                .foregroundColor(message.sender == "user" ? .black: .black)
                .padding()
                .background(message.sender == "user" ? Color(uiColor: ThemeManager.shared.secondaryColor): Color(uiColor: ThemeManager.shared.secondAccentColor))
                .cornerRadius(16)
            if message.sender == "gpt" {Spacer()}
        }
        .id(message.id)
   /*     DispatchQueue.main.async {
                  messageBubbles.append(AnyView(messageBubble))
              }*/
        return messageBubble
    }
    
}

struct InputView_Previews: PreviewProvider {
    static var client = AIClient.shared
    static var fakeList = chatMessage.testMessages
    static var fakeVM = InputViewModel(client: client, chatMessages: fakeList)
    
    static var previews: some View {
        InputView(inputViewModel: fakeVM, chatsList: .constant([fakeVM]))
    }
}

