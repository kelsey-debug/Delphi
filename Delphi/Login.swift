//
//  Login.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/23/23.
// control entry point to app. callback func allows us to return to contentview w/success

import Foundation
import SwiftUI
import Auth0

struct LoginView: View {
    let onLoginSuccess: (Bool) -> Void //callback func to progress into main app post login
    
  var body: some View {
      VStack{
         Text("Welcome")
        Button("Login"){
            login()
        }
        Button("Logout"){
              logout()
        }
      }
 
    }
    
    func login() {
           Auth0
        .webAuth()
        .start { result in
            switch result {
            case .success(let credentials):
                print("Obtained credentials: \(credentials)")
                onLoginSuccess(true)
            case .failure(let error):
                print("Failed with: \(error)")
            }
        }
    }
    
    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    print("Logged out")
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onLoginSuccess: {_ in
            
        })
    }
}