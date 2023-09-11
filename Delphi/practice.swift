//
//  practice.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/21/23.
//

import Foundation
//
//  ContentView.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/16/23.
//main UI for your program

import SwiftUI

class User: ObservableObject { //lets compiler kno this class is monitorable for changes
  //  Mark vars @Published so that any views depending on this class update their content
     @Published var firstName = "Bilbo"
     @Published var lastName = "Baggins"
}

struct secondView: View {
    let name: String
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("hello, \(name)!")
        Button("dismiss"){
            dismiss()
        }
    }
}
/*
struct ContentView: View {
    //@stateobject so we can use one object across views and not lose the value
    //changes made to this state object are automatically updated thanks to @published in class User
    @StateObject private var user = User()
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName).")

            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
            
            Button("show sheet") {
                showSheet.toggle()
            }
            .sheet(isPresented: $showSheet){
                secondView(name: user.firstName)
            }
        }
    }
}
//below func not in final product- just to test and have preview of view as u work
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


*/
///practice swiftUI below
/*   NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of people", selection: $numberofPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                Section {
                    Picker("Percent tip", selection: $percentTip){
                        ForEach(tipPercentages, id: \.self){
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                }header: {
                    Text("How much tip would you like to leave?")
                }
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
            }
            .navigationTitle("welcome")
        }*/
