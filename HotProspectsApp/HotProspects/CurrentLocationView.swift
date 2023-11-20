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
        HStack {
            Text(eventLocation.currentEvent != "" ? (eventLocation.currentEvent) : "Not Attending An Event")
            
            Text("|")
            Button("Update") {
                //show sheet to set the event location
                eventLocation.changeEvent = true
            }
            
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
