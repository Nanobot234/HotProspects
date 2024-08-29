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
    
    /// The current event that a user meets a prospect at
    ///
    /// Every time a new prospect is added, the location that the user states as meeting that prospect is set to this variable. When a user is added, then this variable is reset
    @Published var currentEventMetProspect: String = ""
    
    /// holds the notes a user writes for a prospect here. Used because prospect notes is generated from a seperate view.
    @Published var newProspectNotes: String = ""
    
    /// boolean that shows whether a prospect has been recently added to contacts.
    @Published var addedProspectToContacts: Bool = false

 
    func loadFromUserDefaults() {
        if let value = UserDefaults.standard.string(forKey: "usersLocation") {
            self.currentEventOfUser = value
        }
    }
}


