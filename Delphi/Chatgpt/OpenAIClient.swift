//
//  OpenAIClient.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/28/23.
//

import Foundation
import OpenAIKit
import NIO
import AsyncHTTPClient
import UIKit

//singleton httpclient for lifecycle of app, shuts down on app close. Access AIClient.shared
class AIClient: ObservableObject {
    
    static let shared = AIClient() // ensure a singleton instance of AIClient through lifespan of app using AIClient.shared
    
    var apiKey = Enviroment.apiKey
  //  var organization = Enviroment.organization
    var openAIClient: OpenAIKit.Client
  //  var httpClient: HTTPClient
    var urlSession: URLSession
   
    init() {
        //let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        //httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
        //even tho compoent is being used at a lower thread (thru task in contentview), I am ensuring it is being handled on main thread
       // let configuration = Configuration(apiKey: apiKey)
         urlSession = URLSession(configuration: .default)
         let configuration = Configuration(apiKey: apiKey)
         openAIClient = OpenAIKit.Client(session: urlSession, configuration: configuration)
      //  openAIClient = OpenAIKit.Client(httpClient: httpClient, configuration: configuration)
    }

   
    /* -----------
      system - external instructions to help steer convo with context and behavior suggestions for assistant
      user - msg that actual customer sends
      assistant - msg that gpt generates in response
     ------------ */
    
    //TODO: need to send previous context into bot in order to have real convo
    func request(userMessage: String, onCompletion: (Result<Chat,APIErrorResponse>) -> Void) async {
        do {
            let userMsg: Chat.Message = .user(content: userMessage)
            let sysMsg: Chat.Message = .system(content: "you are a helpful assistant who is curious about this inquiry. Use what you know about dream interpretation and astrology.")
            let completion = try await
            openAIClient.chats.create(model: Model.GPT4.gpt4,
                                      messages: [userMsg, sysMsg],
                                      maxTokens: 6) //maxx tokens to use for a response from api
            print("Response from model: \(String(describing: completion.choices[0].message))")
            onCompletion(.success(completion))
            
        } catch let error as APIErrorResponse {
            print("AI CLIENT ERROR: \(error)")
            onCompletion(.failure(error))
        }
        catch { //TODO 
            print("UNEXPECTED ERROR OCCURED \(error)")
           // let apiError = APIErrorResponse(from: error as! Decoder)
           // onCompletion(.failure(apiError))
        }
    }
 
}

        // --url session method
     /*    let urlSession = URLSession(configuration: .default)
        let configuration = Configuration(apiKey: apiKey)
        openAIClient = OpenAIKit.Client(session: urlSession, configuration: configuration)*/


//may need to expand upon AIClient to fine tune model, tokens, context etc
