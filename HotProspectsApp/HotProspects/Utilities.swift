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
    
}
