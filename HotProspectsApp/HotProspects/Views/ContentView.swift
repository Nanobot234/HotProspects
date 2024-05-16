//
//  ContentView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 8/28/23.
//

import SwiftUI
import UserNotifications
//import Alamofire


/// Parent View of the app. Holds a tab view that in itself contains sub views.
struct ContentView: View {
    
    /// prospects object  , this stateObject is injected into the environemnt
    @StateObject var prospects = Prospects()
    
    @State private var output = "" //output variable to use
    
    @StateObject var eventLocation = EventLocation()
    
    /// The body returns a tabView container that holds 3 ProspectsViews. The prospects StateObject is injected into the environment through the TabView to share with all the ProspectView children
    var body: some View {
  
        TabView {
   
            ProspectsView()
                .tabItem {
                    Label("Prospects", systemImage: "person.3")
                } .onTapGesture {
                    self.hideKeyBoard()
                }
            
            MeView()
                .tabItem {
                    Label("My Profile", systemImage: "person.crop.square")
                }

         SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                } 
            

         
        }
       
        .environmentObject(prospects)
        .environmentObject(eventLocation)
        .navigationBarBackButtonHidden()
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
