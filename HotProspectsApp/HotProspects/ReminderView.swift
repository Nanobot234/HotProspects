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
    @State private var selectedReminderDate = Date()
   // @Binding var showView:Bool
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Select Reminder Date & Time")
                .font(.headline)
            
            
            //check how to make this stack
        
            HStack {
                Spacer()
                
                DatePicker("",selection: $selectedReminderDate, displayedComponents: [.date,.hourAndMinute])
                    .labelsHidden()
                    .border(.red)
                    
                Spacer()
            }
         
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
