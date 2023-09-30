//
//  ItemRowView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/29/23.
//

import SwiftUI


struct ItemRow: View {
    
    @StateObject private var viewModel = RowModel()
    @EnvironmentObject var prospects: Prospects
     //var index:Int
    @State private var locationMet = ""
    let prospect: Prospect
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
                    //have a group for the date, lookup in GPT
                    
                    Spacer()
                    Button (action:{
                        //toggle the popover state to be showhere
                        
                        
                        viewModel.isExpandedShowingNotifcationSchedule = true

                        
                    }) {
                        Image(systemName: "bell")
                            .foregroundColor(.blue)
                    }
                    
                    
                }
                
                Spacer()
                
//                Button("Add Location met") {
//
//                    //here will toggle the alert boolean
//                    showAlert = true //should trigger alert in parent view
//                }
//
                if viewModel.isExpandedShowingNotifcationSchedule {
                    ReminderView(prospect: prospect) //the view to show the reminder interface and things
                }
                
                //ok now if you are uncontacted or everyone filter, then you need to show the reminder button
                
            }
        
            
            else {
                
                Text(prospect.name)
                    .font(.headline)
                Text(prospect.emailAddress)
                    .foregroundColor(.secondary)
                
                
                
                if viewModel.isExpandedShowingNotifcationSchedule {
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
