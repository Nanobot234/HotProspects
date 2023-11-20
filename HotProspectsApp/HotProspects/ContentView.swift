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
        
        
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("All Prospects", systemImage: "person.3")
                }
            
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        .environmentObject(prospects)
        .environmentObject(eventLocation)
       
    }
}

    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Prospects())
    }
}
