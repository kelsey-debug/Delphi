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
   
    //if there was a previous login, populatchatslist with previous data
    //most likely need a dedidcated init 
    
    var body: some View {
      NavigationView {
          ZStack {
         //    Color(ThemeManager.shared.primaryColor)
        //      .edgesIgnoringSafeArea(.all)
             ForEach(chatsList.indices, id: \.self) { index in
                 previousChats(index: index)
             }
            .navigationTitle("Delphis Dialogues")
            .navigationBarItems(trailing:
                               NavigationLink(destination:
                                              InputView(inputViewModel:
                                              InputViewModel(client: client),
                                              chatsList: $chatsList)) {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.black)
                })
         }
      }
   }
    
    //format the archived chats
    func previousChats(index: Int) -> some View {
        let currentVM = chatsList[index]
        let inputView = InputView(inputViewModel: currentVM, chatsList: $chatsList)
        let formattedText = displayStrings(textToFormat: currentVM.chatMessages[0].content)
        return NavigationLink(destination: inputView) {
            Text("\(formattedText)...")
                .foregroundColor(.black)
                .padding()
                .background(Color(uiColor: ThemeManager.shared.secondaryColor))
                .cornerRadius(16)
        }
    }
   
    //format string for display of prev dialogs
    func displayStrings(textToFormat: String) -> String {
       return String(textToFormat.prefix(40))
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
       // ContentView()
    }
}


/*  .toolbar {
 ToolbarItem(placement: .navigationBarLeading) {
 EditButton()
 }
 }*/
