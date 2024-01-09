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
    @State private var showSplash = true
    
  var body: some View {
      ZStack {
          if showSplash {
              splashView()
          } else {
              Color(ThemeManager.shared.accentColor)
              .edgesIgnoringSafeArea(.all)
              VStack {
                  Text("Delphi welcomes you")
                      .font(.title)
                      .bold()
                      .padding(.top, 100)
                  Button("Login"){
                      login()
                  }
                  .foregroundColor(.black)
                  .background( Color(uiColor: ThemeManager.shared.secondaryColor))
                  .cornerRadius(5)
                  .padding(10)
                  Button("Logout"){
                      logout()
                  }.foregroundColor(.black)
                   .background( Color(uiColor: ThemeManager.shared.secondaryColor))
                   .cornerRadius(5)
                  .padding(10)
                  Spacer()
              }
       }
      }
      .onAppear {
          Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                          showSplash = false
                          timer.invalidate()
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
