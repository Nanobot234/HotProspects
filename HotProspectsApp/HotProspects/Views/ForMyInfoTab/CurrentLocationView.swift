//
//  CurrentLocationView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 11/17/23.
//

import SwiftUI

struct CurrentLocationView: View {
    
    @EnvironmentObject var eventLocation: EventLocation
    
    
    var body: some View {
        
        Section {
            HStack {
                Text(eventLocation.currentEventOfUser != "" ? (eventLocation.currentEventOfUser) : "Not Attending An Event")
                    .font(.system(size: 20,design: .rounded))
                
                Text("|")
                //when button is presss will show view that allows user to change location of event they are attending.
                Button("Update") {
                    eventLocation.changeEvent = true
                    
                }
                .buttonStyle(.borderedProminent)
                
            }
        } header: {
            Text("Your Event")
        } footer: {
            Text("The event you are shown as attending. When you scan someones QR code, the location you meet the person will be set to the location here if you have set it.")
        }
    }
    //need to make this
}

struct CurrentLocationView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationView()
            .environmentObject(EventLocation())
    }
}
