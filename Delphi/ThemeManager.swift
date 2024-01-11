//
//  ThemeManager.swift
//  Delphi
//
//  Created by Kelsey Larson on 9/5/23.
//

import Foundation
import SwiftUI
import UIKit

public class ThemeManager {
    public static let shared = ThemeManager()
       
    public let primaryColor: UIColor
    public let secondaryColor: UIColor
    public let accentColor: UIColor
    public let secondAccentColor: UIColor
       
    private init() {
        primaryColor = UIColor(red: 0.90, green: 0.88, blue: 0.85, alpha: 1.00) //grey
        secondaryColor = UIColor(red: 0.98, green: 0.98, blue: 0.95, alpha: 1.00) //cream
        accentColor = UIColor(red: 0.67, green: 0.84, blue: 0.85, alpha: 1.00) //light blue
        secondAccentColor = UIColor(red: 0.57, green: 0.78, blue: 0.81, alpha: 1.00) //darker blue
    }
}
