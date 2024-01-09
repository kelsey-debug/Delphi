//
//  ContentView.swift
//  Delphi
//
//  Created by Kelsey Larson on 8/16/23.
//main UI for your program
import SwiftUI
import Auth0
//the binded chatslist is now being sent from delphiapp. need to udpate $ binding usage here
//to update binded value use $. to just ACCESS current value dont use binding
struct ContentView: View {
//    let client: AIClient //swiftui auto assigns this from val passed in
   // @Binding var chatsList: [InputViewModel] //child view can read and write val of chatslist in the parent view (delphi App)
   @StateObject var userData: SharedUserData
   var existingVm: InputViewModel? //temp holding place for vms that exist and dontneed init
   
   var body: some View {
     NavigationView {
         ZStack {
             Color(ThemeManager.shared.primaryColor)
              .edgesIgnoringSafeArea(.all)
             List {
              ForEach(userData.chatsList.indices, id: \.self) { index in
                 let vm = userData.chatsList[index]
                 if !vm.chatMessages.isEmpty {
                   previousChats(index: index)
                 }
              }
              .onDelete(perform: { indexSet in
                removeRows(at: indexSet)})
             }
             
            .navigationTitle("Delphis Dialogues")
            .foregroundColor(.black)
            .navigationBarItems(trailing:
                               NavigationLink(destination:
                                                //InputView(inputViewModel:InputViewModel(client: AIClient.shared, chatMessages: nil),
                                                InputView(inputViewModel:InputViewModel(client: AIClient.shared, chatMessages: nil),
                                                          chatsList: $userData.chatsList)) {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.black)
                })
            .toolbar {
                EditButton()
                    .accentColor(.black)
            }
            
         }
     }.accentColor(.black)
   }
   
    //format the archived chats,save the chats as they come in.
    func previousChats(index: Int) -> some View {
        userData.saveUserData()
        let currentVM = userData.chatsList[index]
        let inputView = InputView(inputViewModel: currentVM, chatsList: $userData.chatsList)
        let formattedText = displayStrings(textToFormat: currentVM.chatMessages[0].content)
        return NavigationLink(destination: inputView) {
            Text("\(formattedText)...")
                .foregroundColor(.black)
                //.padding()
                //.background(Color(uiColor: ThemeManager.shared.primaryColor))
                //.cornerRadius(16)
        }
        
    }
    
    //format string for display of prev dialogs
    func displayStrings(textToFormat: String) -> String {
       return String(textToFormat.prefix(40))
    }
    
    func removeRows(at offsets: IndexSet) {
        userData.chatsList.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
     //   let client = AIClient.shared
     //   ContentView(client: client) //client no longer needed in contentview
//        let list = [InputViewModel(client: AIClient.shared, chatMessages: chatMessage.testMessages)]
        ContentView(userData: SharedUserData())
    }
}

/*/below func not in final product- just to test and have preview of view as u work

  .toolbar {
 ToolbarItem(placement: .navigationBarLeading) {
 EditButton()
 }
 }
 
 
 .navigationBarItems(trailing:
                    NavigationLink(destination:
                                     InputView(inputViewModel: existingVm ?? InputViewModel(client: AIClient.shared, chatMessages: nil),
                                             chatsList: $chatsList)) {
     Image(systemName: "square.and.pencil")
         .foregroundColor(.black)
     })
 */
