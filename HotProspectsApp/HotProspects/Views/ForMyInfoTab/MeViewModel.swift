//
//  MeViewModel.swift
//  HotProspects
//
//  Created by Nana Bonsu on 6/12/24.
//

import Foundation


class MeViewModel: ObservableObject {
    
    
    @Published var name = "" {
        didSet {
            UserDefaults.standard.set(name, forKey: "users_name")
        }
    }
    
    @Published var emailAddress = "" {
        didSet {
            UserDefaults.standard.set(emailAddress, forKey: "users_email")
        }
    }
    @Published var phoneNumber = "" {
        didSet {
            UserDefaults.standard.set(phoneNumber, forKey: "users_phone")
        }
    }
    
    @Published var discordUsername = "" {
        didSet {
            UserDefaults.standard.set(phoneNumber, forKey: "discord_username")
        }
    }
    
    @Published var linkedinUsername = "" {
        didSet {
            UserDefaults.standard.set(linkedinUsername, forKey: "linkedin_username")
        }
    }
    
    @Published  var nameCopy = "" {
        didSet {
            UserDefaults.standard.set(nameCopy, forKey: "users_name_copy")
        }
            //TODO: Change the rest here. 
    }
    @Published  var emailAddressCopy = "" {
        didSet {
            UserDefaults.standard.set(emailAddressCopy, forKey: "users_email_copy")
        }
    }
    @Published  var phoneNumberCopy = "" {
        didSet {
            UserDefaults.standard.set(phoneNumberCopy, forKey: "users_phone_copy")
        }
     
    }
    @Published  var linkedinUsernameCopy = "" {
        didSet {
            UserDefaults.standard.set(linkedinUsernameCopy, forKey: "Linkedin_Username_copy")
        }
       
    }
    @Published  var discordUsernameCopy = "" {
        didSet {
            UserDefaults.standard.set(discordUsernameCopy, forKey: "Discord_Username_copy")
        }
    }
    
    
    init() {
        loadUserInfo()
    }
    
//    func saveUserInfo() {
//        UserDefaults.standard.set(name, forKey: "users_name")
//        UserDefaults.standard.set(emailAddress, forKey: "users_email")
//        UserDefaults.standard.set(phoneNumber, forKey: "users_phone")
//        UserDefaults.standard.set(linkedinUsername, forKey: "linkedin_username")
//        UserDefaults.standard.set(discordUsername, forKey: "discord_username")
//        
//        //check if the email was toggled and then do this!!
//        
//      
//       
//        
//        UserDefaults.standard.set(linkedinUsernameCopy, forKey: "Linkedin_Username_copy")
//        UserDefaults.standard.set(discordUsernameCopy, forKey: "Discord_Username_copy")
//        
//        //saves the value of the feilds to the array before.
//        
//        //Continue here!!
//    }
    
    
    func loadUserInfo() {
        
        name = UserDefaults.standard.string(forKey: "users_name") ?? ""
        emailAddress = UserDefaults.standard.string(forKey: "users_email") ?? ""
        phoneNumber = UserDefaults.standard.string(forKey:"users_phone") ?? ""
        linkedinUsername = UserDefaults.standard.string(forKey: "linkedin_username") ?? ""
        discordUsername = UserDefaults.standard.string(forKey: "discord_username") ?? ""
        
        nameCopy = UserDefaults.standard.string(forKey: "users_name_copy") ?? ""
        emailAddressCopy = UserDefaults.standard.string(forKey: "users_email_copy") ?? ""
        phoneNumberCopy = UserDefaults.standard.string(forKey: "users_phone_copy") ?? ""
        linkedinUsernameCopy = UserDefaults.standard.string(forKey: "Linkedin_Username_copy") ?? ""
        discordUsernameCopy =  UserDefaults.standard.string(forKey: "Discord_Username_copy") ?? ""
           
    }
    
}
