//
//  LangChainClient.swift
//  Delphi
//
//  Created by Kelsey Larson on 10/31/23.
//class == reference, struct == copies created

import Foundation
import UIKit
import NIO
import SwiftUI
import LangChain
import AsyncHTTPClient
import PineconeSwift

class LangChainClient: ObservableObject {
   var LangChainManager = LangChainManagement()
   
   func createTemplate(context: String) async -> String {
       let indexContext = await LangChainManager.queryIndex(newQuery: context)
       var contextStrings = [String]()
       
       for elem in indexContext {
          if let indexString = elem.data(using: .utf8) {
           do {
               if let json = try JSONSerialization.jsonObject(with: indexString, options: []) as? [String: Any],
                  let stringValue = json["text"] as? String {
                   contextStrings.append(stringValue)
               }
           } catch {
               print("Error parsing JSON: \(error)")
           }
         }
       }
        
       var template =
    
       """
           You are an expert in the field of dream analysis and interpretation. Your goal is to provide understanding and insight into the dreams of the user. Help them apply the findings to their conscious life. Allow the conversation to flow naturally, diving deeper into the dream if the user provides more details. If the user asks general questions, you can explore those topics as well, without having to use dream information.

           When responding, adopt a casual tone of conversation and avoid using overly academic language. If it makes sense, you can directly quote the information related to the user's inquiry and relate it to their question. Use as much infomation from below as possible. Please give priority to the information attached when providing your response:
       """
      
       if !contextStrings.isEmpty {
           template += contextStrings.joined(separator: "\n\n") 
       } else {
           template += "No relevant data found."
       }
       
       print("TEMPLATE RESULTS:", template)
       return template
    }
    
}

 
