//
//  ChatMessage.swift
//  Delphi
//
//  Created by Kelsey Larson on 9/5/23.
// the message itself that is inside the list of chats.
//need to archive the chatMessage struct in order to be an NSData type. Need to also make the enum encodable

import Foundation

struct chatMessage: Codable {
    let id: String
    let content: String
    let dateCreated: Date
   // let sender: chatType
    let sender: String
}

public enum chatType: String, Codable {
    case user
    case gpt
}


extension chatMessage {
   /* static let testMessages = [
        chatMessage(id: UUID().uuidString, content: "hi there user", dateCreated: Date(), sender: .user),
        chatMessage(id: UUID().uuidString, content: "this is a msg", dateCreated: Date(), sender: .gpt),
        chatMessage(id: UUID().uuidString, content: "childhood thoughts user", dateCreated: Date(), sender: .user),
        chatMessage(id: UUID().uuidString, content: "im aliveeee", dateCreated: Date(), sender: .gpt)
    ]*/
    static let testMessages = [
        chatMessage(id: UUID().uuidString, content: "hi there user", dateCreated: Date(), sender: "user"),
        chatMessage(id: UUID().uuidString, content: "this is a msg", dateCreated: Date(), sender: "gpt"),
        chatMessage(id: UUID().uuidString, content: "childhood thoughts user", dateCreated: Date(), sender: "user"),
        chatMessage(id: UUID().uuidString, content: "im aliveeee", dateCreated: Date(), sender: "gpt")
    ]
}
