//
//  ProspectEventViewModel.swift
//  HotProspects
//
//  Created by Nana Bonsu on 2/21/24.
//

import Foundation


@MainActor class EventLocation: ObservableObject {
    
    
    @Published var currentEventOfUser: String = "" {
        didSet {
            UserDefaults.standard.set(currentEventOfUser,forKey: "usersLocation")
        }
        
    }
    
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


