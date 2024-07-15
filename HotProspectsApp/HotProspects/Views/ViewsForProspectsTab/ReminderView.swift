//
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
        
        NavigationView {
            VStack {
                if prospect.isReminderSet {
                    reminderSetView
                } else {
                    createReminderView
                }
            }
            .navigationTitle(prospect.isReminderSet ? "Reminder to Contact \(prospect.name)": "Create a Reminder")
            .navigationBarTitleDisplayMode(.inline)
          
        }
       
    }
    
    /// Message to show when a user sets a reminder for a prospect
    var reminderSetView: some View {

        let component = prospect.lastReminderDate.split(separator: ",").map{ $0.trimmingCharacters(in: .whitespaces)}
        
            
       return VStack(spacing: 15) {
            Text("\(component[0]) at \(component[1])")
                .font(.title2)
                .fontWeight(.bold)
            
           
            
            confirmationButton(title:"Change") {
                prospects.reminderToggle(prospect)
            }
        }
    }
    
    var createReminderView: some View {
        
        VStack(spacing: 20) {
   
            Text("Select Date & Time to Contact \n \(prospect.name)")
                .font(.title)
                .multilineTextAlignment(.center)
    
            HStack {
                Spacer()
                
                DatePicker("",selection: $selectedReminderDate, displayedComponents: [.date,.hourAndMinute])
                    .labelsHidden()
                    .border(.red)
                    .scaleEffect(x: 1.3, y: 1.3)
                    .frame(width: 100, height: 100)
                
                Spacer()
            }
            
            // When the reminder button is clicked, the system schedules a notification.
            
            confirmationButton(title:"Set Reminder") {
                
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

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        
        let prospect = Prospect(name: "Nana Bonsu", emailAddress: "Nbonsu2000", phoneNumber: "6453534323")
        
        //Prospect(id: UUID(), name: "John Doe", isReminderSet: false, lastReminderDate: "")
        let showReminder = Binding.constant(true)
        ReminderView(prospect: prospect, showReminderView: showReminder)
            .presentationDetents([.fraction(0.4)])
    }
}
