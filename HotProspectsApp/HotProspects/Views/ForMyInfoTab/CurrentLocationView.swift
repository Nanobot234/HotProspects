//
//  CurrentLocationView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 11/17/23.
//

import SwiftUI

/// Displays a view where a user can change the event they are stated as attending
struct CurrentLocationView: View {
    
    @EnvironmentObject var eventLocation: EventLocation
    
    
    var body: some View {
        
        Section {
            HStack {
                Text(eventLocation.currentEventOfUser != "" ? (eventLocation.currentEventOfUser) : "No Location Added")
                    .font(.system(size: 20,design: .rounded))
                //Give some min length here!!
                Text("|")
                //when button is presss will show view that allows user to change location of event they are attending.
                Button("Update") {
                    eventLocation.changeEvent = true
                }
                .buttonStyle(.borderedProminent)
                
            }
        } header: {
            Text("Your Location")
        } footer: {
            Text(" When you scan someones QR code, the location you meet the person will be set to this location that you specify. If you dont add your lcoation, you will be asked to enter the location you met the person every time .")
        }
        .headerProminence(.increased)
    }
    //need to make this
}

struct CurrentLocationView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationView()
            .environmentObject(EventLocation())
    }
}
