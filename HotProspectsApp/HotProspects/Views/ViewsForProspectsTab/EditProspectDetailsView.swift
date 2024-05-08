//
//  EditProspectDetailsView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 5/6/24.
//



import SwiftUI
import SafariServices


/// Screen that displays prospect details and allow
struct EditProspectDetailsView: View {
    
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var prospect: Prospect //make this a binding changes would reflect, in previously but not on memory. Can
    
    @EnvironmentObject var eventLocation: EventLocation //seeign the current event
    @EnvironmentObject var prospects: Prospects
    
    /// The text for the location feild
    @State  var locationText: String = ""
    
    @State var prospectNotesText: String = ""
    
    @State var showWebView: Bool = false
    
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
                
                if(!prospect.linkedinProfileURL.isEmpty){
                    
                    Section  {
                    //Button here for the link to Linkdin
                    Button("View \(prospect.name)'s LinkedIn") {
                        showWebView = true
                    }
                    //also have
                } header:
                {
                    Text("Socials")
                }
                    
            }
                if(!prospect.linkedinProfileURL.isEmpty){
                    Section {
                        Text(prospect.discordUsername)
                    } header: {
                        Text("\(prospect.name)'s Discord")
                    }
                }
                //Different section for discord username and copy
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
                
                print("Profile URL" + prospect.linkedinProfileURL)
                
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
            .sheet(isPresented: $showWebView, content: {
                SafariView(url: URL(string:prospect.linkedinProfileURL)!)
            })
            
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
