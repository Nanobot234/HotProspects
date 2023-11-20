//
//  EditProspectDetailsView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 10/23/23.
//

import SwiftUI



struct EditProspectDetailsView: View {
   
    
     @Binding var prospect: Prospect //make this a binding changes would reflect, in previously but not on memory. Can
    @EnvironmentObject var prospects: Prospects
   
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                //TODO: Add spacing between form items and also between section header?
                Section(header: Text("Update Prospect info")) {
                    TextField(" Name", text: $prospect.name)
                    TextField("Email Address", text: $prospect.emailAddress)
                    TextField("Phone Number", text: $prospect.phoneNumber)
                }
                
                //section ehre for updating location met
                Section {
                    TextField("Add Location Met", text: $prospect.locationMet)
                } header: {
                    Text("Location Where You Met A Prospect")
                }

                
            }
            .onAppear {
                print(prospect.locationMet)
                print("Im here")
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
                    dismiss()
                }
                
            }
            
        }
        .navigationTitle("Edit Contact Information")
        .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    /// initialize state variables with values of `prospect` object
    /// - Parameter prospect: The prospect that the user selects to edit their information


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
