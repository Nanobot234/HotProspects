//
//  ItemRowView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/29/23.
//

import SwiftUI


struct ItemRow: View {
    

    
    var id =  UUID()
 
    @EnvironmentObject var prospects: Prospects
    @EnvironmentObject var eventLocation: EventLocation
    
    @State var prospect: Prospect
    @State private var showReminder: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    let filter: ProspectsView.FilterType
    @Binding var toast: Bool
    @State var showreminderSheet = false
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            HStack {
                
                if(filter == .none) {
                    Image(systemName: prospect.isContacted ? "person.crop.circle.fill.badge.checkmark":"person.crop.circle.badge.xmark")
                        .font(.system(size:24))
                        .foregroundColor(prospect.isContacted ? Color.green: Color.red)
                }
                
                VStack(alignment: .leading, spacing: 10){
                    Text(prospect.name)
                        .font(.system(size:25,weight: .bold))
                    
                    Text(prospect.locationMet != "" ? "Met At " + prospect.locationMet + "on \(prospect.currentDate.formatted())":"No Event Added")
                        .font(.system(size: 20))
                }
                
                Spacer()
                
                if(filter == .none || filter == .uncontacted) {
                    Image(systemName: "bell")
                        .foregroundColor(.blue)
                        .font(.system(size: 25))
                        .onTapGesture {
                            prospects.reminderToggle(prospect)
                            print(prospect.reminderToggle)
                        }
                }
            }
            
        }
        .onAppear {
          
            //If the user is going to an event, save the prospects 
            if(eventLocation.currentEventOfUser != "" && prospect.locationMet == "") {
                
                prospect.locationMet = eventLocation.currentEventOfUser //this doesnt save to the object array? or more li
                print("Location of user matching global", prospect.locationMet)
                prospects.addLocationMet(prospect)
            } else if(prospect.locationMet != "") {
                return
            }
            else {
                prospect.locationMet = eventLocation.currentEventMetProspect
                prospects.addLocationMet(prospect)
                eventLocation.currentEventMetProspect = ""
            }
        }
        
        .sheet(isPresented: $prospect.reminderToggle) {
            ReminderView(prospect: prospect)
                .presentationDetents([.fraction(0.4)])
        }
        
        .alert("Confirm Deletion", isPresented: $showDeleteAlert) {
            
            Button("Cancel", role:.cancel) {}
            
            Button("Yes", role: .destructive) {
                prospects.remove(prospect)
            }
            
            
        } message: {
            Text("Are you sure you want to delete this prospect")
        }
        
        .swipeActions(allowsFullSwipe: false) {
            
            if(prospect.isContacted) {
                SwipeActionButtons.markUncontactedButton {
                    
                    prospects.toggle(prospect)
                }
                .tint(.blue)
                
            } else {
                
                SwipeActionButtons.markContactedButton {
                    prospects.toggle(prospect)
                }
                .tint(.green)
            }
            
            SwipeActionButtons.deleteContactButton {
                showDeleteAlert = true
            }
            .tint(.red)
            
            
            SwipeActionButtons.addProspectToContactButton {
                
                saveProspectToContacts(email: prospect.emailAddress, phoneNumber: prospect.phoneNumber, name: prospect.name, locationMet: prospect.locationMet) { result in
             
                    if(result){
                        toast = true
                    }
                }
                
                
            }
            .tint(.cyan)
        
        }
        //create here!
    }
    
    func updateProspectLocation() {
        prospect.locationMet = eventLocation.currentEventMetProspect
    }
    
    
}
//struct ItemRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRow()
//    }
//}
