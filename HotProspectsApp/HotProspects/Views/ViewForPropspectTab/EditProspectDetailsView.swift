//
//  EditProspectDetailsView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 10/23/23.
//

import SwiftUI



struct EditProspectDetailsView: View {
    
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var prospect: Prospect //make this a binding changes would reflect, in previously but not on memory. Can
    
    @EnvironmentObject var eventLocation: EventLocation //seeign the current event
    @EnvironmentObject var prospects: Prospects
    
    /// The text for the location feild
    @State  var locationText: String = ""
    
    @State var prospectNotesText: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                
                
                //TODO: Add spacing between form items and also between section header?
                Section(header: Text("Update \(prospect.name)'s contact information")) {
                    TextField(" Name", text: $prospect.name)
                    TextField("Email Address", text: $prospect.emailAddress)
                    TextField("Phone Number", text: $prospect.phoneNumber)
                }
      
                //section ehre for updating location met
                Section {
                    TextField("Location or Event Where You Met This Prospect", text: $locationText)
                } header: {
                    Text("Location Where You Met This Prospect")
                }
                
                Section {
                    TextEditor(text: $prospectNotesText)
                        .frame(width: 200,height: 300)
                } header: {
                    Text("Notes about \(prospect.name)")
                }
                
            }
            .onAppear {
                
                setProspectLocationandNotesFromEnvironment()
                print(prospect.locationMet)
                
            }
                      
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    //When user presses save, update propspext with changed values.
                    Button("Save") {
                        
                        //should check
                        prospect.locationMet = locationText
                        prospects.addLocationMet(prospect)
                        
                        prospect.prospectNotes = prospectNotesText
                        prospects.addNotesForProspect(prospect)
                        
                        
                        //save all the updated details in the prospect
                        prospects.updateProspectDetails(prospect)
                        dismiss()
                    }
                    
                }
                
            }
            .navigationTitle("Edit Contact Information")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }

    /// sets the `locationText` and `prospectNotesText` feild with the value from the envionment.
    ///
    /// This fucntion is run when `onAppear` is called
    func setProspectLocationandNotesFromEnvironment() {
        if(prospect.locationMet == "") {
            locationText = eventLocation.currentEventOfUser
        } else {
            locationText = prospect.locationMet
        }
        prospectNotesText = prospect.prospectNotes
    }
}

//struct EditProspectDetailsView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        @Binding var prospect = Prospect.example
//
//        prospect.emailAddress = "Nbonsu2000@gmail.com"
//        prospect.phoneNumber = "6467012471"
//
//        return EditProspectDetailsView(prospect: $prospect)
//    }
//}
