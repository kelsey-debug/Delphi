//
//  ContentView.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/16/23.
//main UI for your program

import SwiftUI
import Auth0


//how can I make sure same convo can continue, w/o multiple instances of API call
struct ContentView: View {
    @State var numbers = [InputView]()
//    @State var numbers = [Int]()
    @State var count = 1
 
    var body: some View {
       NavigationView {
         LazyVStack {
            List {
                    ForEach(numbers, id: \.id ){ inputView in
                        Text("Row \(inputView.id)")
                    }
                    .onDelete(perform: removeRows)
                }
                NavigationLink(destination: InputView(numbers: $numbers)) {
                    Text("Go to InputView")
                  }
            }
            .navigationTitle("Previous Convos")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func removeRows(at offsets: IndexSet){
        numbers.remove(atOffsets: offsets)
    }
}


//below func not in final product- just to test and have preview of view as u work
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


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
