//
//  DelphiApp.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/16/23.
//initial launch of program + for creating something to keep alive during entire app launch

import SwiftUI

@main
struct DelphiApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var isLoggedin = false
    let client = AIClient.shared
    var userStorage = UserStorage.shared
    
    var body: some Scene {
        WindowGroup {
            if isLoggedin {
                ContentView(client: client) //pass binding to contentview to use singleton instance
                //ContentView() //pass binding to contentview to use singleton instance
            } else {
                LoginView(onLoginSuccess: { success in
                     isLoggedin = success
                })
            }
        }
        .onChange(of: UIApplication.shared.applicationState) { state in
            switch state {
            case .inactive, .background: //TODO:  need to modify this when user comes back to  app after being in BG
                print("app client shutting down")
                appDelegate.clientShutdown(singletonClient: client)
            case .active:
                //app is about to be active
                print("app active")
            @unknown default:
                break
            }
        }
    }
    

//when app is about to close, take all chats inside contentViews "chatslist"
//use .chatMessages instead of $chatMessages bc I want actual value
//$ gives us the projected value from property wrapper published
 func saveUserData(chatData: [InputViewModel]) {
    var temp = [[chatMessage]]()
    for viewModel in chatData {
        let msgs = viewModel.chatMessages
        temp.append(msgs)
    }
    userStorage.saveChatMessage(chatMessages: temp)
 }

}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func clientShutdown(singletonClient: AIClient) {
    //    do {
       //     try singletonClient.httpClient.syncShutdown() //try? siliently discards the error do catch to handle it.
            singletonClient.urlSession.invalidateAndCancel()
            print("client has shutdown")
     /*   } catch {
            print("error on client shutdown \(error)")
        }*/
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Perform any necessary app setup
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Perform actions when the app is about to become inactive
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Perform actions when the app enters the background
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Perform actions when the app is about to terminate
        // it's important to shutdown the httpClient after all requests are done, even if one failed. See: https://github.com/swift-server/async-http-client
       
       
    }
}
