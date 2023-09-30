//
//  ReminderView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/29/23.
//

import SwiftUI

struct ReminderView: View {
    @EnvironmentObject var viewModel:RowModel
    var prospect:Prospect
    @State private var selectedReminderDate = Date()
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Select Reminder Date & Time")
                .font(.headline)
            
            
            //check how to make this stack
            Spacer()
            DatePicker("",selection: $selectedReminderDate, displayedComponents: [.date,.hourAndMinute])
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            
            Button("Set Reminder") {
                
               
                Utilties.addContactNotificationReminder(for: prospect, notifyDate: selectedReminderDate)
                
                viewModel.isExpandedShowingNotifcationSchedule = false
                //how to run the following!
             //   ProspectsView.addNotification(for: prospect, notifyDate: selectedReminderDate)
                //isPopoverVisible.toggle() //dismiss the popover.
            }
            .buttonStyle(.automatic)
        }
    }
}

//struct ReminderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReminderView()
//    }
//}
