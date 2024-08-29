//
//  ApiKeys.swift
//  HotProspects
//
//  Created by Nana Bonsu on 4/16/24.
//

import Foundation



enum APIKeys {
    
    static var LinkedInClientID: String {
         let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: filePath)
        
         let value = plist?.object(forKey: "LinkedinInClientID") as! String
        return value
    }
    
    static var LinkedInClientSecret: String {
         let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")!
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        let value = plist?.object(forKey: "LinkedInClientSecret") as! String
        return value
    }
    
    
    static var DiscordClientID: String {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")!
                
        let plist = NSDictionary(contentsOfFile: filePath)
        
        let value = plist?.object(forKey: "DiscordCleintID") as! String
        return value
    }
    
    static var DiscordClientSecret: String {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")!
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        let value = plist?.object(forKey: "DiscordClientSecret") as! String
        
        
        return value
    }
    
}
