//
//  Utilities.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/28/23.
//

import Foundation
import SwiftUI



class Utilties {

        static func addContactNotificationReminder(for prospect: Prospect, notifyDate: Date) {
            //get notification center,
            let center = UNUserNotificationCenter.current()
            
            //here I am creating a function that im saving as a variable. This is so that I can use it later
            let addRequest = {
                let content = UNMutableNotificationContent()
                content.title = "Reminder to Contact \(prospect.name)"
                content.subtitle = prospect.emailAddress + "\n" + "Phone: \(prospect.phoneNumber)"
                content.sound = UNNotificationSound.default
                
                //now will just trigger it for 5 seocnds in the future
                
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notifyDate)
              
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                //here create the request after defining the content
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                //now add the request to the notifcation center
                center.add(request) { error in
                    print("Your error: " + (error?.localizedDescription ?? "No error"))
                    
                }
            }
            
            //now will use api methods to schedule notifications only when the user has allowed
            
            center.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    addRequest()
                } else {
                    //request authorization form the user for the app
                    center.requestAuthorization(options: [.alert, .badge, .sound]) { success, err in
                        if success {
                            addRequest()
                        } else {
                            print("Not allowed")
                        }
                    }
                }
            }
        }
 
    
    /// Adjust the contact information array for a prospect to deal with missing contact infomation
    /// - Parameter details: <#details description#>
    /// - Returns: <#description#>
   static func adjustDetailsArray(details: [String]) -> [String] {
 
        //completion: @escaping (Bool) -> Void
        var contactDetails = details
        let lengthOfArray = contactDetails.count
        //first check if element at positon 1 is a valid email,
        
        //TODO: Need     to examine the array, element, and check if the number is less than or equal to
        guard lengthOfArray >= 2 else {return contactDetails}
        if(isValidContactPoint(details[1], validationType: "email") == false){ //change here!
                    contactDetails.insert("", at: 1) //insert empty string since this should be there but isnt
                }
       //if length of the array is at least 3 then check if the phone number is valid or not
        guard lengthOfArray >= 3 else {return contactDetails}
        if(isValidContactPoint(details[2], validationType: "phoneNumber") == false){
                    contactDetails.insert("", at: 2)
        }
       
       guard lengthOfArray >= 4 else {return contactDetails}
       if(details[3] == ""){
           contactDetails.insert("", at: 3)
       }
        //other contact info will be here!!!
       guard lengthOfArray >= 5 else {return contactDetails}
       if(details[4] == ""){
           contactDetails.insert("", at: 4)
       }
        return contactDetails
                //then check for phone
    }
    
   static func isValidContactPoint(_ inputString: String,validationType: String) -> Bool {
        // Regular expression pattern for a simple email validation
        switch validationType {
        case "email":
            let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: inputString)
        case "phoneNumber":
            let phoneRegex = #"^\d{10}$"#
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phonePredicate.evaluate(with: inputString)
        default:
            return true
            
        }
    }
    
    //Linkedin Auth function calls
    
//    func LinkedInAuth(_ serviceParameters: [String: String]) {
//
//
//
//
//
//    }
}
