//
//  OpenAIClient.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/28/23.

//TODO: need to add documentloader from langchain-swift library instead of openaikit
import Foundation
import OpenAIKit
import NIO
import AsyncHTTPClient
import UIKit

//singleton httpclient for lifecycle of app, shuts down on app close. Access AIClient.shared
/***
COST - limit to 130 words, 200 tokens
 0.006 cents per input, 0.012 cents per output = roughly  0.018 cents per exchange. if there are 15 exchanges, maybe 25 cents overall per conversation
 ***/
class AIClient: ObservableObject {
    static let shared = AIClient() // ensure a singleton instance of AIClient through lifespan of app using AIClient.shared
    
    var apiKey = Enviroment.apiKey
  //  var organization = Enviroment.organization //not needed if I have only 1 org
    var openAIClient: OpenAIKit.Client
    var urlSession: URLSession
   
    init() {
      urlSession = URLSession(configuration: .default)
      let configuration = Configuration(apiKey: apiKey)
      openAIClient = OpenAIKit.Client(session: urlSession, configuration: configuration)
    }

   
    /* -----------
      system - external instructions to help steer convo with context and behavior suggestions for assistant
      user - msg that actual customer sends
      assistant - msg that gpt generates in response
     ------------ */
    //TODO: need to send previous context into bot in order to have real convo
    //previous context send
    //token calculations
    func request(userMessage: String, systemMessage: String, previousMessages: [String], onCompletion: (Result<Chat,APIErrorResponse>) -> Void) async {
        do {
            //todo: move the math for extracting strings from prevMessages to caller if it works here
            //move the parameters for request customization elsewhere
            let userMsg: Chat.Message = .user(content: userMessage)
            let sysMsg: Chat.Message = .system(content: systemMessage)
            var startIndex = 0
            var requestMsgs = [Chat.Message]()
            
            requestMsgs.append(userMsg)
            requestMsgs.append(sysMsg)
            //take the last 3 user messages for context
            if previousMessages.count > 4 {
              startIndex = previousMessages.count - 3 // Starting index of the subrange
            }
            
            //if less than 4 entries, take the entire array into account. Otherwise, limit it to the last 3
            for index in startIndex..<previousMessages.count {
                let element = previousMessages[index]
                requestMsgs.append(.user(content: element))
            }
            
            let completion = try await
            openAIClient.chats.create(model: Model.GPT4.gpt4,
                                      messages: requestMsgs,
                                      maxTokens: 300) //maxx tokens to use for a response from api
            //  print("Response from model: \(String(describing: completion.choices[0].message))")
            onCompletion(.success(completion))
            
        } catch let error as APIErrorResponse {
            print("AI CLIENT ERROR: \(error)")
            onCompletion(.failure(error))
        }
        catch {  
            print("UNEXPECTED ERROR OCCURED \(error)")
        }
    }
   
}



//may need to expand upon AIClient to fine tune model, tokens, context etc

//this method has threading semaphore issue I cannot resolve
/**  //let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
 //httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
 //even tho compoent is being used at a lower thread (thru task in contentview), I am ensuring it is being handled on main thread
// let configuration = Configuration(apiKey: apiKey)*/
