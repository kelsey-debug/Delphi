//
//  ChatMessage.swift
//  Delphi
//
//  Created by Kelsey Larson on 9/5/23.
// the message itself that is inside the list of chats.

import Foundation

struct chatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: chatType
}

public enum chatType {
    case user
    case gpt
}


extension chatMessage {
    static let testMessages = [
        chatMessage(id: UUID().uuidString, content: "hi there user", dateCreated: Date(), sender: .user),
        chatMessage(id: UUID().uuidString, content: "this is a msg", dateCreated: Date(), sender: .gpt),
        chatMessage(id: UUID().uuidString, content: "childhood thoughts user", dateCreated: Date(), sender: .user),
        chatMessage(id: UUID().uuidString, content: "im aliveeee", dateCreated: Date(), sender: .gpt)
    ]
}
