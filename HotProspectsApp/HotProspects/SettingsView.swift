//
//  AboutAppView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/15/24.
//

import SwiftUI

/// Contains privacy info, FAQs , etc
struct SettingsView: View {
    
    @State var isFaceIDEnabled = false
    @State var meTabDescription = ""
    @State var propectsTabDescription = "In the Prospects tab, use the blue icon on the bottom right of the prspects page to scan a prospects QR code and you will instantly have access to all the contact info they share with you."
    var body: some View {
        //NavigatioNView here!!
        Form {
            Section {
                HStack {
                    
                    Image(systemName:"faceid")
                    Toggle(isOn: $isFaceIDEnabled) {
                        Text("Face ID") //TODO: Add functionality for FACEID here, or touch
                    }
                    
              
                }
            } header: {
                Text("Preferences")
            }
            
            
            Section {
                //Help Section here
                
//                NavigationLink(destination: Text(), label: <#T##() -> View#>)
                Button("Questions or Comments?") {
                    //then mail code here
                    
                }
                NavigationLink {
                    appTabDscription
                } label: {
                    Text("How to use this app")
                }
                
                
                //Questions send email
                //Have ideas comments
            } header: {
                Text("Help")
            }
            //m aybe add linkedin and sign in info here
            
            
        }
        .navigationTitle("Setting")
    }
    
    var appTabDscription: some View {
        //mored details here
         Text(propectsTabDescription)
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
