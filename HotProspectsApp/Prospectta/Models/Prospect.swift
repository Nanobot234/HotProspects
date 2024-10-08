//
//  Prospect.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/11/23.
//

import SwiftUI


/// Defines the properties of a Prospect.
///  
/// In this app, a Prospect is a person whose contact information the user saves in order to contact them at a later time


// TODO: Get AI refectoring ideas for this class
class Prospect: Identifiable, Codable, Equatable, Hashable  {
 

    var prospectID = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var phoneNumber = ""
     var isContacted = false
    
    ///The place or event where the person met his contact
    var locationMet = ""
    
    /// The current date that the user saves the  prospects contact information
    var currentDateMetUser : Date? = nil

    /// Toggles the button for the reminder on and off. The false, or off, state indicated that the user has not set a reminder to contact this prospect. The true state means the user has set one.
    var isReminderSet = false
    
    /// Notes that the user makes about this prospect
    var prospectNotes = ""
    
    ///  The most recent date that a user has scheduled to contact this prospect..
    var lastReminderDate = ""
    
    /// The linkedin username of a prospect that a user adds
    var linkedinProfileURL = ""
    
    ///  The discord username of a prospect the user adds
    var discordUsername = ""
    
    var isProspectAddedToContacts = false
    
    var profilePhotoData: Data? = nil
       var profilePhoto: UIImage {
           get {
               if let data = profilePhotoData {
                   return UIImage(data: data) ?? UIImage()
               }
               return UIImage()
           }
           set {
               profilePhotoData = newValue.pngData()
           }
       }
     
     init() {}
     
     init(name: String, emailAddress: String, phoneNumber: String) {
         self.name = name
         self.emailAddress = emailAddress
         self.phoneNumber = phoneNumber
         
     }
    
    /// Intializer uaed primarily when creating a new selected Prospect so that it works well
    init(id: UUID, name: String, emailAddress: String, phoneNumber: String, locationMet: String, prospectNotes: String) {
        self.prospectID = id
        self.name = name
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
        self.locationMet = locationMet
        self.prospectNotes = prospectNotes
        
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
