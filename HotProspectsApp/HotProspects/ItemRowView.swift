//
//  ItemRowView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/29/23.
//

import SwiftUI


struct ItemRow: View {
    
    @EnvironmentObject var prospects: Prospects
     //var index:Int
    @State private var locationMet = ""
    @Binding var prospect: Prospect
    let filter: ProspectsView.FilterType
    var body: some View {
        
        VStack(alignment: .leading) {
            if(filter == .none) {
                HStack {
                    //ok, I can just make variable for the string, that will show the correct icon depending on the name
                    
                    Image(systemName: prospect.isContacted ? "person.crop.circle.fill.badge.checkmark":"person.crop.circle.badge.xmark")
                        .font(.system(size:24))
                    VStack(alignment: .leading, spacing: 10){
                        Text(prospect.name)
                            .font(.headline)
                        
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                            
                        
                        Text(prospect.phoneNumber)
                            .foregroundColor(.secondary) //phone number here
                        
                        Text(prospect.locationMet != "" ? prospect.locationMet:"Person didnt add the event")
                    }
                    
                    Spacer()
                    Button (action:{
                        //toggle the popover state to be showhere
                        prospect.reminderToggle.toggle()

                        print(prospect.reminderToggle)
                        
                    }) {
                        Image(systemName: "bell")
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                if prospect.reminderToggle {
                    ReminderView(prospect: prospect) //the view to show the reminder interface and things
                }
            
            }
            else {
                
                Text(prospect.name)
                    .font(.headline)
                Text(prospect.emailAddress)
                    .foregroundColor(.secondary)
            
                
                if prospect.reminderToggle {
                    ReminderView(prospect: prospect)
                }
            }
        }
       
       

        
        .swipeActions {
            if(prospect.isContacted) {
                Button {
                    prospects.toggle(prospect)
                } label: {
                    Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                }
                .tint(.blue)
            } else {
                //make another swipe action, foe the uncontacted list
                Button {
                    prospects.toggle(prospect)
                    
                } label: {
                    Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                }
                .tint(.green)
                Button {
                    prospects.remove(prospect)
                } label: {
                    Label("Delete Prospect", systemImage: "trash")
                }
            }
        }
     
    }
    //create here!
}
//struct ItemRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRow()
//    }
//}
