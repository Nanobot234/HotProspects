//
//  UserandProspectView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 11/21/23.
//

import SwiftUI

struct UserAndProspectLocationView: View {
    //UserandProspetVentView
    /// The array of prospects stored in the environment.
    @EnvironmentObject var prospects: Prospects
    
    @EnvironmentObject var eventLocation: EventLocation
  
    @Environment(\.dismiss) var dismiss

    /// String indicates if a user updates the location that they are attending or sets a location met for an individual prospect,
     var addReasonMessage:String
    
    @State var userLocationString = ""
    
  //  var prospect: Prospect
    var body: some View {
        
        NavigationView {
            
            Form {
                
                //...
                Section {
                    TextField("Location", text: addReasonMessage == "userLocationUpdate" ? $userLocationString: $eventLocation.currentEventMetProspect)
                    
                        .font(.title2)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled(true)
                } header: {
                    Text(addReasonMessage == "userLocationUpdate" ? "The Location Where Your Meeting Prospects" : "The location Where You Met This Prospect")
                }
                
                
                
                if(addReasonMessage == "prospectLocation") {
                    Section {
                        TextEditor(text: $eventLocation.newProspectNotes)
                            .frame(maxWidth:.infinity, maxHeight: .infinity)
                            .foregroundStyle(.primary)
                            .padding(.horizontal,20)
                            .border(.black, width: 0.5)
                    } header: {
                        Text("Notes about this Prospect")
                        
                    }
                }
     
            }
        
            .navigationTitle(addReasonMessage == "userLocationUpdate" ? "What Event are You Attending?" : "Prospect Details")
            .navigationBarTitleDisplayMode(addReasonMessage == "userLocationUpdate" ? .inline : .large)
   
            
            .onAppear {
                userLocationString = eventLocation.currentEventOfUser
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarButton("Save", systemImage: "") {
                        
                        eventLocation.currentEventOfUser = userLocationString //here puts the current event that the user is into the environment.
                        dismiss()
                        
                    }
                }
            } 
            
        }
         
    }
}


struct UserandProspectView_Previews: PreviewProvider {
    static var previews: some View {
        UserAndProspectLocationView(addReasonMessage: "prospectLocation")
            .environmentObject(EventLocation())
            
    }
}

