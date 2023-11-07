//
//  UserData.swift
//  Delphi
//
//  Created by Kelsey Larson on 10/25/23.
//

import Foundation

class SharedUserData: ObservableObject {
    @Published var chatsList: [InputViewModel] = [] //published allows observers to automatically get the changes made
    var userStorage = UserStorage.shared
    let client = AIClient.shared
    
    //$ gives us the projected value from property wrapper published
    func saveUserData() {
        var temp = [[chatMessage]]()
        for viewModel in chatsList {
            let msgs = viewModel.chatMessages //use .chatMessages instead of $chatMessages bc I want actual value
            temp.append(msgs)
        }
        userStorage.saveChatMessage(chatMessages: temp)
    }
    
    //retrieve previously stored msgs, assign to viewmodels otherwise return array of empty vms
    func fetchUserData() {
        var fetchedVM = [InputViewModel]()
        let chatData = userStorage.getChatMessages()
        for chat in chatData { // so chat = [ChatMessage]
            let inputVM = InputViewModel(client: client, chatMessages: chat)
            fetchedVM.append(inputVM)
        }
        chatsList = fetchedVM
    }
}
