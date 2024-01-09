//
//  Enviroment.swift
//  Delphi
//
//  Created by Kelsey Larson on 9/6/23.
//

import Foundation

public enum Enviroment {
    enum Keys {
     static let apiKey = "OPENAI_API_KEY"
     static let organization = "OPENAI_ORGANIZATION"
     static let pineconeKey = "PINECONE_KEY"
     static let pineconebaseURL = "PINCONE_BASE_URL"
   //  static let auth0Domain = "AUTH0_DOMAIN" //INSERTAUTH0DOMAIN
//     static let auth0clientID = "AUTH0_CLIENT_ID" //INSERTAUTH0CLIENTID
    }
    
    private static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
/*    private static let auth0Dict: [String: Any] = {
        guard let auth0PlistPath = Bundle.main.path(forResource: "auth0", ofType: "plist"),
              let auth0PlistData = FileManager.default.contents(atPath: auth0PlistPath),
              let auth0Plist = try? PropertyListSerialization.propertyList(from: auth0PlistData, format: nil) as? [String: Any]
           else {
               fatalError("`auth0.plist` not found or missing data.")
           }
        return auth0Plist
    }()
    
    static let auth0Domain: String = {
        guard let key = Enviroment.auth0Dict[Keys.auth0Domain] as? String else {
            fatalError("pineconebaseURL in plist not found")
        }
        return key
    }()

    static let auth0clientID: String = {
        guard let key = Enviroment.auth0Dict[Keys.auth0clientID] as? String else {
            fatalError("pineconebaseURL in plist not found")
        }
        return key
    }()*/
    
    static let pineconebaseURL: String = {
        guard let key = Enviroment.infoDict[Keys.pineconebaseURL] as? String else {
            fatalError("pineconebaseURL in plist not found")
        }
        return key
    }()
    
    static let pineconeKey: String = {
        guard let key = Enviroment.infoDict[Keys.pineconeKey] as? String else {
            fatalError("pineconeKey in plist not found")
        }
        return key
    }()
    
    static let apiKey: String = {
        guard let key = Enviroment.infoDict[Keys.apiKey] as? String else {
            fatalError("api key in plist not found")
        }
        return key
    }()
    
    static let organization: String = {
        guard let org = Enviroment.infoDict[Keys.organization] as? String else {
            fatalError("organization in plist not found")
        }
        return org
    }()
}




