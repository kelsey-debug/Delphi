//
//  DelphiApp.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/16/23.
//initial launch of program + for creating something to keep alive during entire app launch

import SwiftUI

@main
struct DelphiApp: App {
   
   // @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var isLoggedin = false
    @StateObject var sharedUserData = SharedUserData() //store instance of reference type data. owns the data.
    
    init() {
    //    appDelegate.sharedUserData = sharedUserData
    }
    
    var body: some Scene {
        WindowGroup {
               langViewtest()
        /*    if isLoggedin {
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
            }*/
        }
    }
}
/*
class AppDelegate: NSObject, UIApplicationDelegate {
    
    var sharedUserData: SharedUserData!  // Reference to the shared data declared inside delhpiApp struct
    
    override init() {
        super.init()
    }
    
    init(sharedUserData: SharedUserData) {
        self.sharedUserData = sharedUserData  // Initialize the reference to shared data
     //   sharedUserData.fetchUserData()
       // super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
           // Do any necessary app setup
  //         sharedUserData.fetchUserData()
           return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Perform any necessary app setup
   //     sharedUserData.fetchUserData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Perform actions when the app is about to terminate
        // it's important to shutdown the httpClient after all requests are done, even if one failed. See: https://github.com/swift-server/async-http-client
       print("potat0")
     //   sharedUserData.client.urlSession.invalidateAndCancel() //need to check if nil before this
        sharedUserData.saveUserData()
    }
}*/
