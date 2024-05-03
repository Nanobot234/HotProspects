//
//  ReminderView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/29/23.
//

import SwiftUI

struct ReminderView: View {
    
    
    @EnvironmentObject var prospects: Prospects
    
    var prospect:Prospect
    
    /// The date that the user decides to set a prospect reminder at
    @State private var selectedReminderDate = Date()
    
    @Binding var showReminderView: Bool
    
    
    /// A date picker is shown along with a button allowing the user to set the reminder..
    var body: some View {
        
        VStack(spacing: 20) {
            
            if prospect.isReminderSet {
                
                reminderSetView
            } else {
                createReminderView
            }           
        }
       
    }
    
    /// Message to show when a user sets a reminder for a prospect
    var reminderSetView: some View {
        
        VStack {
            Text("You already have a reminder to contact \(prospect.name)")
            
            Text("It's on\(prospect.lastReminderDate)")
            
            Button("Change") {
                prospects.reminderToggle(prospect)
            }
        }
    }
    
    var createReminderView: some View {
        
        VStack(spacing: 20) {
   
            Text("Select Date & Time to Contact This Prospect")
                .font(.headline)
    
            HStack {
                Spacer()
                
                DatePicker("",selection: $selectedReminderDate, displayedComponents: [.date,.hourAndMinute])
                    .labelsHidden()
                    .border(.red)
                
                Spacer()
            }
            
            // When the reminder button is clicked, the system schedules a notification.
            Button("Set Reminder") {
                
                Utilties.addContactNotificationReminder(for: prospect, notifyDate: selectedReminderDate) //adds the remidner for the particular prospect that the user chooses
                prospect.lastReminderDate = selectedReminderDate.formatted() //saves the date string for the particular prospect.
                prospects.saveReminderForProspect(prospect) //this saves the reminder string for the prospect that the user wants to be reminded to contact.
                             
                showReminderView = false
                prospects.reminderToggle(prospect) //toggles the
    
            }
            .buttonStyle(.bordered)
        }
    }
    
}

//struct ReminderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReminderView()
//    }
//}
