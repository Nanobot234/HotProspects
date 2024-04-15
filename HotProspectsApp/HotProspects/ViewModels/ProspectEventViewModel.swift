//
//  ProspectEventViewModel.swift
//  HotProspects
//
//  Created by Nana Bonsu on 2/21/24.
//

import Foundation


@MainActor class EventLocation: ObservableObject {
    
    
    ///  The event that the user is currently attending. The user can set this event or leave it empty. If they set this event, then every prospect they meet will have this location as the `locationMet` string.
    @Published var currentEventOfUser: String = "" {
        didSet {
            UserDefaults.standard.set(currentEventOfUser,forKey: "usersLocation")
        }
        
    }
    
    ///  boolean set when user changes event
    @Published var changeEvent: Bool = false
    

    @Published var currentEventMetProspect: String = ""
    
    /// holds the notes a user writes for a prospect here:
    @Published var newProspectNotes: String = ""

 
    func loadFromUserDefaults() {
        if let value = UserDefaults.standard.string(forKey: "usersLocation") {
            self.currentEventOfUser = value
        }
    }
}


