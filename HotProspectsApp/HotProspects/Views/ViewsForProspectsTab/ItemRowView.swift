//
//  ItemRowView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/29/23.
//

import SwiftUI

//TODO: Fix the formatting of this sheet
///  Displays a prospect's name, date and time a user meets a prospect, and location details
struct ItemRow: View {
  
    /// indentifies each `ItemRow` object. Used to identify objects that the user has selected to be deleted.
    var id =  UUID()
    
    @EnvironmentObject var prospects: Prospects
    @EnvironmentObject var eventLocation: EventLocation
    
    /// A saved prospect whose information is displayed in this row
    ///
    @State var prospect: Prospect
    /// boolean to display or hide the sheet enabling a user to change or view scheduling reminders
    ///
    @State private var showReminderView: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State var showreminderSheet: Bool = false
    
    ///Determine whether or not to display toast. The toast is defined in `ProspectView`
   
    @Binding var canAccessUsersContacts: Bool
    
    ///  Indicates whether the prospect has beena dded to the users contact books.
    @State var addedToContacts: Bool = true
    
    
    @Binding var tappedProspectID: UUID?
    
   @State var showContactView: Bool = false
    @State var showPopover: Bool = false
    

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
                    
                    let prospectString = "Met At: \(prospect.locationMet)\nDate: \(extractDate(from: prospect.currentDateMetUser!))\nTime: \(extractTime(from: prospect.currentDateMetUser!))"
                    
                    Group {
                        Text(prospect.locationMet != "" ? "Met At: \(prospect.locationMet)": "No Location Added") //met at her!
                        Text("Date: \(extractDate(from: prospect.currentDateMetUser!))")
                        Text("Time: \(extractTime(from: prospect.currentDateMetUser!))")
                    }
                    .font(.system(size:22,weight: .medium))
                    .padding(5)
                    
                    
                }
                
                Spacer()
                HStack {
                    if((filter == .all || filter == .uncontacted) && !prospect.isReminderSet) {
                        Image(systemName: "bell")
                            .foregroundColor(.blue)
                            .font(.system(size: 25))
                            .onTapGesture {
                                showReminderView = true
                                print(prospect.isReminderSet)
                            }
                    } else if prospect.isReminderSet {
                        Image("checkmark-bell-notification-icon")
                            .resizable() // Make the image resizable
                            .foregroundStyle(Color.blue)
                            .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                            .frame(width: 25, height: 25) // Set the frame size
                            .onTapGesture {
                                showReminderView = true
                            }
                    }
                    
                    if prospect.isProspectAddedToContacts {
                   
                        Image(systemName: "person.fill.checkmark")
                            .foregroundStyle(Color.blue)
                            .font(.system(size: 25))
                            .onTapGesture {
                                showPopover = true
                            }
                    }
                }
                .popover(isPresented: $showPopover,attachmentAnchor: .point(.top)) {
                    let contactsText = "This prospect is saved in your contacts"
                    Text(contactsText)
                        .frame(width: 200, height: 100)
                        .presentationCompactAdaptation(.popover)
                        .padding()
                }
            }
            
            }
        .background(tappedProspectID == prospect.prospectID ? Color.gray : Color.clear)
        .padding(10)
        .swipeActions(edge: .trailing, allowsFullSwipe: false){
            
            swipeActionButtons(for: prospect)
        }

        .onAppear {
            addedToContacts = prospect.isProspectAddedToContacts
            eventLocation.currentEventMetProspect = "" //this rests the feild where you met the last user at. 
        }
        
        .sheet(isPresented: $showReminderView) {
            
            ReminderView(prospect: prospect, showReminderView: $showReminderView)
                .presentationDetents([.fraction(0.4)])
        }
        .sheet(isPresented: $showContactView) {
            AddContactView(prospect: prospect)
        }
        
        .alert("Confirm Deletion", isPresented: $showDeleteAlert) {
            
            Button("Cancel", role:.cancel) {}
            
            Button("Yes", role: .destructive) {
                prospects.remove(prospect)
            }
            
        } message: {
            Text("Are you sure you want to delete this prospect")
        }
        .contextMenu {
            Button {
                
                if canAccessUsersContacts {
                    showContactView = true
                }

            } label: {
                Label("Add to Contacts", systemImage: "plus")
            }
        }
        
    }
    
    /// Sets the location the user meets the prospect to the current event the user is attending

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
    
   
    
    
    /// Determines where  the user met a ecently added prospect.
 
    private func swipeActionButtons(for prospect: Prospect) -> some View {
        Group {
            if prospect.isContacted {
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
                if canAccessUsersContacts {
                    showContactView = true
                }
               
                
//                saveProspectToContacts(email: prospect.emailAddress, phoneNumber: prospect.phoneNumber, name: prospect.name, locationMet: prospect.locationMet) { result in
//                    if result {
//                        presentToast = true
//                    }
//                }
            }
        }
    }
    
    
    
}

//struct ItemRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        let prospect = Prospect(name: "nana", emailAddress: "nbonsu2000@gmail.com", phoneNumber: "6467012471")
//        prospect.locationMet = "bar"
//        prospect.currentDateMetUser = Date()
//        prospect.isProspectAddedToContacts = true
//        let filter = ProspectsView.FilterType.all
//        
//        let contactsAccess = Binding.constant(true)
//    
//        return ItemRow(prospect: prospect, canAccessUsersContacts: contactsAccess, tappedProspectID: nil, filter: filter)
//    }
//}


