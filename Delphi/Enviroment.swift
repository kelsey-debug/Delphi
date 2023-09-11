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
    }
    
    private static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
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
