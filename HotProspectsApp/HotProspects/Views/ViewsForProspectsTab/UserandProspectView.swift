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
    
 //   @State var userLocationString = ""
    
  //  var prospect: Prospect
    var body: some View {
        
        NavigationView {
            
            Form {
                
                //...
                Section {
                    TextField("Location", text: addReasonMessage == "userLocationUpdate" ? $eventLocation.currentEventOfUser: $eventLocation.currentEventMetProspect)
                    //so if the user is updating location save ir in location string if not the event variable
                        .font(.title2)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                } header: {
                    Text("Location")
                } footer: {
                    Text(addReasonMessage == "userLocationUpdate" ? "The location where you meet new prospects will be set to this location" : "The location where you met this prospect")
                        .font(.title3)
                    
                }
                .headerProminence(.increased)
                
                
                
                if(addReasonMessage == "prospectLocation") {
                    Section {
                        TextEditor(text: $eventLocation.newProspectNotes)
                            .frame(maxWidth:.infinity, maxHeight: .infinity)
                            .foregroundStyle(.primary)
                            .padding(.horizontal,20)
                           
                    } header: {
                        Text("Notes about this Prospect")
                        
                    }
                    .headerProminence(.increased)
                }
     
            }
        
            .navigationTitle(addReasonMessage == "userLocationUpdate" ? "Where are you At?" : "Prospect Details")
            .navigationBarTitleDisplayMode(.inline)
   
            
            .onAppear {
                
              //  userLocationString = eventLocation.currentEventOfUser //the stored user location will be this.
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarButton("Save", systemImage: "") {
                        
                        if(addReasonMessage == "userLocationUpdate") {
                          //  eventLocation.currentEventOfUser = userLocationString
                        } else  {
                            
                        }
                         //here puts the current event that the user is into the environment.
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

