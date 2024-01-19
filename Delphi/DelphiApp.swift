//
//  DelphiApp.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/16/23.

import SwiftUI

@main
struct DelphiApp: App {
   
    @State var isLoggedin = false
    @StateObject var sharedUserData = SharedUserData()
    
    init(){}
    
    var body: some Scene {
        WindowGroup {
            if isLoggedin {
                ContentView(userData: sharedUserData)
                .onAppear() {
                  sharedUserData.fetchUserData()
                }
                .task {
                   await sharedUserData.PopulateIndex()
                }
            } else {
                LoginView(onLoginSuccess: { success in
                     isLoggedin = success
                })
            }
        }
    }
}
