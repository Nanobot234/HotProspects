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
   
    ///
    /// String indicates if a user updates the location that they are attending or sets a location met for an individual prospect,
     var addReasonMessage:String
    
    @State var userLocationString = ""
    
  //  var prospect: Prospect
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center, spacing: 10) {
                Text(addReasonMessage == "userLocationUpdate" ? "What Event are You Attending?" : "Enter the Location or Event You Met This Prospect At")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                  
                
               
                //depending on the reason for adding location. bind the text to different variables
                TextField("Location", text: addReasonMessage == "userLocationUpdate" ? $eventLocation.currentEventOfUser: $eventLocation.currentEventMetProspect)
                    .frame(width: 300, height: 150)
                
                    .textInputAutocapitalization(.never)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled(true)
                
                
                //TODO: Change the size of this textfield? make it larger and smaller too!
                //                .background(
                //                                RoundedRectangle(cornerRadius: 8)
                //                                    .stroke(Color.red, lineWidth: 1) // Change the color and line width as needed
                //                            )
                //change the border color here
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        toolbarButton("Save", systemImage: "") {
                            
                            dismiss()
                            
                        }
                    }
                }
                
            }
        }
       
         
    }
}


struct UserandProspectView_Previews: PreviewProvider {
    static var previews: some View {
        UserAndProspectLocationView(addReasonMessage: "userLocationUpdate")
            
    }
}
