//
//  ContentView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 8/28/23.
//

import SwiftUI
import UserNotifications



struct ContentView: View {
    
    @StateObject var prospects = Prospects()
    @StateObject private var viewModel = RowModel()
    @State private var output = "" //output variable to use
    
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
        .environmentObject(prospects) //this makes all the views int eh tap view , have this object to be diaplayed
        .environmentObject(viewModel)
    }
}
//        Text(output)
//            .task {
//                await fetchReadings()
//            }
    
    
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Prospects())
    }
}
