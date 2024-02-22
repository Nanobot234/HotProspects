//
//  ItemRowView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/29/23.
//

import SwiftUI


struct ItemRow: View {
  
    /// indentifies each `ItemRow` object. Used to identify objects that the user has selected to be deleted.
    var id =  UUID()
    
    @EnvironmentObject var prospects: Prospects
    @EnvironmentObject var eventLocation: EventLocation
    
    @State var prospect: Prospect
    
    @State private var showReminder: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State var showreminderSheet = false
    
    ///Determine whether or not to display toast. The toast is defined in  `ProspectView`
    @Binding var toast: Bool
    
    
    let filter: ProspectsView.FilterType

    var body: some View {
        
        //Displays text detailing the date and location a user meets a prospect.
        VStack(alignment: .center, spacing: 20) {
            HStack {
                
                // adds a contacted or uncontacted icon if the filter type is et to view all Prospects.
                if(filter == .all) {
                    Image(systemName: prospect.isContacted ? "person.crop.circle.fill.badge.checkmark":"person.crop.circle.badge.xmark")
                        .font(.system(size:24))
                        .foregroundColor(prospect.isContacted ? Color.green: Color.red)
                }
                
                VStack(alignment: .leading, spacing: 10){
                    Text(prospect.name)
                        .font(.system(size:25,weight: .bold))
                    
                    let prospectString = "Met At: \(prospect.locationMet)\nDate: \(extractDate(from: prospect.currentDate))\nTime: \(extractTime(from: prospect.currentDate))"
                    Text(prospect.locationMet != "" ? prospectString: "No Location Added\n Date: \(extractDate(from: prospect.currentDate)) \nTime: \(extractTime(from: prospect.currentDate))")
                        .font(.system(size: 20))
                    
                }
                
                Spacer()
                
                if(filter == .all || filter == .uncontacted) {
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
            
            //if the user has stated that they are attending an event, then set the location the user meets the prospect to the event they are attending
            if(eventLocation.currentEventOfUser != "" && prospect.locationMet == "") {
                
                prospect.locationMet = eventLocation.currentEventOfUser
                  
                print("Location of user matching global", prospect.locationMet)
                prospects.addLocationMet(prospect)
            }
            else if(prospect.locationMet != "") { return}
            
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
    
    /// Sets the location the user meets the prospect to the current event the user is attending
    func updateProspectLocation() {
        prospect.locationMet = eventLocation.currentEventMetProspect
    }
    
    func extractDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func extractTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
    
    
}
//struct ItemRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRow()
//    }
//}
