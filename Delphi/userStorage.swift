//
//  userStorage.swift
//  Delphi
//
//  Created by Kelsey Larson on 10/3/23.
//a temporary solution for storing users data for an MVP.

import Foundation

class UserStorage {
    
    let defaults = UserDefaults.standard
    static var shared = UserStorage()
    
    init() {
     let lastExecutionDateKey = "lastExecutionDate"
        //the value/key doesnt exist yet, so set it to nil so it can be set later
      if defaults.object(forKey: lastExecutionDateKey) == nil { //comeback to this logic
       defaults.set(nil, forKey: lastExecutionDateKey)
      }
    }
    
    func getChatMessages() -> [[chatMessage]] {
       if let encodedData = defaults.data(forKey: "Chats") {
          let decoder = JSONDecoder()
          if let decodedData = try? decoder.decode([[chatMessage]].self, from: encodedData) {
              return decodedData
          }
       }
       return [[chatMessage]]()
       //return defaults.object(forKey: "Chats") as? [[chatMessage]] ?? [[chatMessage]]()
    }
    
    //save the chatMessages for ONE instance of a inputVM
    func saveChatMessage(chatMessages: [[chatMessage]]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(chatMessages) {
            defaults.set(encodedData, forKey: "Chats")
        }
    }
    
}


/*var tempStorage = [String]()
        for msgs in chats {
          let content = msgs.content
          tempStorage.append(content)
        }*/  //not gonna work, I need entire chatMEssage to restore chat.
