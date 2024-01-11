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
    
    @StateObject var sharedUserData = SharedUserData() //store instance of reference type data. owns the data.
    
    init() {
  //     appDelegate.sharedUserData = sharedUserData
    }
    
    var body: some Scene {
        WindowGroup {
          //     langViewtest()
            if isLoggedin {
                //pass binding to contentview to use singleton instance
//                ContentView(chatsList: $sharedUserData.chatsList)
                ContentView(userData: sharedUserData)
                .onAppear() {
                  sharedUserData.fetchUserData()
                }
            } else {
                LoginView(onLoginSuccess: { success in
                     isLoggedin = success
                })
            }
        }
    }
}
