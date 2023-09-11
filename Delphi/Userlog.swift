//
//  Userlog.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/23/23.
//

import Foundation
 

struct Userlog: Codable {
    var date: Date
    var title: String
    var log: String //is theoretically long enough for a journal entry
}
