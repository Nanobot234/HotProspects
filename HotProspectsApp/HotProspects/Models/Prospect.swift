//
//  Prospect.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/11/23.
//

import SwiftUI


///Defines the properties of a Prospect.
///
///In this app, a Prospect is a person whose contact information the user saves in order to contact them at a later time
class Prospect: Identifiable, Codable, Equatable, Hashable  {
 

    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var phoneNumber = ""
     var isContacted = false
    
    ///The place or event where the person met his contact
    var locationMet = ""
    
    /// The current date that the user saves the  prospects contact information
    var currentDate = Date()

    /// Toggles the button for the reminder on and off
    var reminderToggle = false
    
    /// Notes that the user makes about this prospect
    var prospectNotes = ""
     
     init() {}
     
     init(name: String, emailAddress: String, phoneNumber: String) {
         self.name = name
         self.emailAddress = emailAddress
         self.phoneNumber = phoneNumber
         
     }

    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        if(lhs.name == rhs.name && lhs.emailAddress == rhs.emailAddress && lhs.phoneNumber == rhs.phoneNumber) {
            return true
        } else {
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
           
       }
     
  }
