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
    //need to mark these as published so the view is updated
   /* @State private var newMessage = ""
    @State private var placeHolderMessage = ""
    @State private var chatMessages: [chatMessage] = chatMessage.testMessages*/
    //@Binding var chatsList: [InputView] //borrowed from contentview
   
    //let client: AIClient
    @ObservedObject var inputViewModel: InputViewModel
    @Binding var chatsList: [InputViewModel] //list of existing chats to add to
    
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(inputViewModel.chatMessages, id:  \.id) { message in
                        messageView(message: message)
                    }
                }
            }
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
//               .keyboardType(.default)
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
        .onDisappear {
            //always update UI related on main thread
            DispatchQueue.main.async {
                if !chatsList.contains(where:{$0.id == inputViewModel.id})
                {
                    self.chatsList.append(inputViewModel)
                }
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
 
}

struct InputView_Previews: PreviewProvider {
    static var fake = [InputView]()
    static var client = AIClient.shared
    static var fakeList = chatMessage.testMessages
    
    static var previews: some View {
       // InputView(chatsList: .constant(fake), client: client)
        InputView(inputViewModel: InputViewModel(), chatsList: .constant(fakeList) )
    }
}

            