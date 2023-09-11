//
//  DelphiApp.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/16/23.
//initial launch of program + for creating something to keep alive during entire app launch

import SwiftUI

@main
struct DelphiApp: App {
    @State var isLoggedin = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedin {
               ContentView()
            } else {
                LoginView(onLoginSuccess: { success in
                     isLoggedin = success
                })
            }
        }
    }
}
