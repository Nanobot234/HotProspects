//
//  ItemRowView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/29/23.
//

import SwiftUI


struct ItemRow: View {
    
    @EnvironmentObject var prospects: Prospects
    @EnvironmentObject var eventLocation: EventLocation
    
    @State var prospect: Prospect
    @State private var showReminder: Bool = false
    @State private var showDeleteAlert: Bool = false
    let filter: ProspectsView.FilterType
    @Binding var toast: Bool
    
    var body: some View {
        
        VStack(alignment: .center) {
            if(filter == .none) {
                HStack {
                    //ok, I can just make variable for the string, that will show the correct icon depending on the name
                    
                    Image(systemName: prospect.isContacted ? "person.crop.circle.fill.badge.checkmark":"person.crop.circle.badge.xmark")
                        .font(.system(size:24))
                        .foregroundColor(prospect.isContacted ? Color.green: Color.red)
                    VStack(alignment: .leading, spacing: 10){
                        Text(prospect.name)
                            .font(.headline)
                        
                 //if user hasnt set an event they are going to show this, if they have then
                        if(eventLocation.currentEvent != "" && prospect.locationMet == "") {
                            Text("Met At " + eventLocation.currentEvent + " on \(prospect.currentDate.formatted())")
                        } else {
                            
                            Text(prospect.locationMet != "" ? "Met At " + prospect.locationMet + " on \(prospect.currentDate.formatted())":"No Event Added")
                            
                        }
                    }
                    
                    
                    Spacer()
                    
                    //                    Image(systemName: "person.crop.circle.badge.plus")
                    //                        .foregroundColor(.blue)
                    //
                    
                    Image(systemName: "bell")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            prospects.reminderToggle(prospect)
                            print(prospect.reminderToggle)
                        }
                }
                
                if prospect.reminderToggle {
                    ReminderView(prospect: prospect)
                }
                

            }
            else {
                VStack(alignment: .leading,spacing: 10) {
                    Text(prospect.name)
                        .font(.headline)
                    //                    Text("Email " + prospect.emailAddress)
                    //                        .foregroundColor(.secondary)
                    //                    Text("Phone Number " + prospect.phoneNumber)
                    //
                    Text(prospect.locationMet != "" ? "Met At " + prospect.locationMet + " on \(prospect.currentDate.formatted())":"No Event Added")
                }
       
            }
        }
        
        .alert("Confirm Deletion", isPresented: $showDeleteAlert) {
            
            Button("Cancel", role:.cancel) {}
            
            Button("Yes", role: .destructive) {
                prospects.remove(prospect)
            }
            
            
        } message: {
            Text("Are you sure you want to delete this prospect")
        }
        
        .swipeActions {
            
            
            if(prospect.isContacted) {
                
                SwipeActionButtons.markUncontactedButton {
                    
                    prospects.toggle(prospect)
                }
                .tint(.red)
                
            } else {
                
                SwipeActionButtons.markContactedButton {
                    prospects.toggle(prospect)
                }
            }
            
            SwipeActionButtons.deleteContactButton {
                showDeleteAlert = true
            }
            
            SwipeActionButtons.addProspectToContactButton {
                
                saveProspectToContacts(email: prospect.emailAddress, phoneNumber: prospect.phoneNumber, name: prospect.name, locationMet: prospect.locationMet)
            }
            
            
            
        }
        //create here!
    }
}
//struct ItemRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRow()
//    }
//}
