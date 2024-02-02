//
//  Login.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/23/23.

import Foundation
import SwiftUI
import Auth0

struct LoginView: View {
    let onLoginSuccess: (Bool) -> Void //callback func to progress into main app post login
    
  var body: some View {
      ZStack {
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
    
    func login() {
           Auth0
        .webAuth()
        .start { result in
            switch result {
            case .success(_):
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
