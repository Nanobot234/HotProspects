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
    
    /// A date picker is shown along with a button allowing the user to set the reminder..
    var body: some View {
        
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
                
                Utilties.addContactNotificationReminder(for: prospect, notifyDate: selectedReminderDate)
                prospects.reminderToggle(prospect) //toggles the reminder for the prospect your on, and thus hides the view
                
                //add a toast here
                
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
