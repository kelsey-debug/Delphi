//
//  userStorage.swift
//  Delphi
//
//  Created by Kelsey Larson on 10/3/23.
//

//a temporary solution for storing users data for an MVP. Eventually this will need to be a sql connection or something
//TODO: may have to extend chatMessage to be codable for this level of simplicicty
import Foundation

class UserStorage {
    
    let defaults = UserDefaults.standard
    static var shared = UserStorage()
   
    func getChatMessages() -> [[chatMessage]] {
        return defaults.object(forKey: "Chats") as? [[chatMessage]] ?? [[chatMessage]]()
    }
    
    //save the chatMessages for ONE instance of a inputVM
    func saveChatMessage(chatMessages: [[chatMessage]]) {
        defaults.set(chatMessages, forKey: "Chats")
    }
    
}


/*var tempStorage = [String]()
        for msgs in chats {
          let content = msgs.content
          tempStorage.append(content)
        }*/  //not gonna work, I need entire chatMEssage to restore chat.
