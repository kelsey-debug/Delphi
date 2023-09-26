//
//  ThemeManager.swift
//  Delphi
//
//  Created by Kelsey Larson on 9/5/23.
//

import Foundation
import SwiftUI
import UIKit

//prob make this public struct... I dont need this to be a class or not because the colors are instance members
// class allows one singleton copy passed around, struct would result in multiple imut copies
//enum doesnt allow stored properties
public class ThemeManager {
    public static let shared = ThemeManager()
       
    public let primaryColor: UIColor
    public let secondaryColor: UIColor
    public let accentColor: UIColor
    public let secondAccentColor: UIColor
       
    private init() {
        primaryColor = UIColor(red: 0.22, green: 0.28, blue: 0.44, alpha: 1.00)
        secondaryColor = UIColor(red: 0.35, green: 0.31, blue: 0.52, alpha: 1.00)
        accentColor = UIColor(red: 0.53, green: 0.42, blue: 0.59, alpha: 1.00)
        secondAccentColor = UIColor(red: 0.84, green: 0.76, blue: 0.88, alpha: 1.00)
    }
}
