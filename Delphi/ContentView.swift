//
//  ContentView.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/16/23.
//main UI for your program
import SwiftUI
import Auth0

struct ContentView: View {
    let client: AIClient //swiftui auto assigns this from val passed in
    @State var chatsList = [InputViewModel]()
    
    var body: some View {
        NavigationView {
            ForEach(chatsList.indices) { index in
                previousChats(index:index)
            }
            .navigationTitle("Previous Convos")
            .navigationBarItems(trailing:
                                    NavigationLink(destination:
                                         InputView(inputViewModel:
                                    InputViewModel(client: client), chatsList: $chatsList)) {
                Image(systemName: "square.and.pencil")
            })
        }
    }
    
    //format the archived chats
    func previousChats(index: Int) -> some View {
        let inputView = InputView(inputViewModel: chatsList[index], chatsList: $chatsList)
        return NavigationLink(destination: inputView) {
            Text("\(chatsList[index].id.uuidString)")
                .foregroundColor(.white)
                .padding()
                .background(.blue)
                .cornerRadius(16)
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        chatsList.remove(atOffsets: offsets)
    }
}

//below func not in final product- just to test and have preview of view as u work
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let client = AIClient.shared
        ContentView(client: client)
    }
}


/*  .toolbar {
 ToolbarItem(placement: .navigationBarLeading) {
 EditButton()
 }
 }*/
