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

class AIClient {
    
    var apiKey = Enviroment.apiKey
    var organization = Enviroment.organization
    
    var openAIClient: OpenAIKit.Client
   
    init() {
        print("Here's your api key value -> \(apiKey)")
        print("Here's your api org value -> \(organization)")
        // Generally we would advise on creating a single HTTPClient for the lifecycle of your application and recommend shutting it down on application close.
     /*   let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
        
        defer {
            // it's important to shutdown the httpClient after all requests are done, even if one failed. See: https://github.com/swift-server/async-http-client
            try? httpClient.syncShutdown()
        }
        
        let configuration = Configuration(apiKey: apiKey, organization: organization)
        openAIClient = OpenAIKit.Client(httpClient: httpClient, configuration: configuration)*/
        let urlSession = URLSession(configuration: .default)
     //   let configuration = Configuration(apiKey: apiKey, organization: organization)
        let configuration = Configuration(apiKey: apiKey)
        openAIClient = OpenAIKit.Client(session: urlSession, configuration: configuration)
    }

   
    /*
      system - external instructions to help steer convo with context and behavior suggestions for assistant
      user - msg that actual customer sends
      assistant - msg that gpt generates in response
     */
    func request(userMessage: String, onCompletion: (Result<Chat,APIErrorResponse>) -> Void) async {
        do {
            let userMsg: Chat.Message = .user(content: userMessage)
            let sysMsg: Chat.Message = .system(content: "you are a helpful assistant who is curious about this inquiry. Use what you know about dream interpretation and astrology.")
            let completion = try await
            openAIClient.chats.create(model: Model.GPT4.gpt4,
                                      messages: [userMsg, sysMsg])
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

