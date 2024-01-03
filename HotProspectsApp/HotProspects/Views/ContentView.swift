//
//  ContentView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 8/28/23.
//

import SwiftUI
import UserNotifications



/// Parent View of the app. Holds a tab view that in itself contains sub views.
struct ContentView: View {
    
    /// prospects object  , this stateObject is injected into the environemnt
    @StateObject var prospects = Prospects()
    
    @State private var output = "" //output variable to use
    
    @StateObject var eventLocation = EventLocation()
    
    /// The body returns a tabView container that holds 3 ProspectsViews. The prospects StateObject is injected into the environment through the TabView to share with all the ProspectView children
    var body: some View {
        
        //ok so I need to filter out thea rray bindings based on the toggle that is selected
        //so , based on the placeholder, if you want to exclude it then just filter out based on text
        //but to onclude 
        
        TabView {
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
            
            ProspectsView()
                .tabItem {
                    Label("All Prospects", systemImage: "person.3")
                }
            
            
           
            
//            ProspectsView(filter: .uncontacted)
//                .tabItem {
//                    Label("Uncontacted", systemImage: "questionmark.diamond")
//                }
//                .onTapGesture {
//                    self.hideKeyBoard()
//                }
//
         
        }
        .environmentObject(prospects)
        .environmentObject(eventLocation)
        .onAppear {
            
            eventLocation.loadFromUserDefaults()
        }
       
    }
}

    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Prospects())
    }
}
