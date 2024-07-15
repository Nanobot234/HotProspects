//
//  SwipeActionButton.swift
//  HotProspects
//
//  Created by Nana Bonsu on 11/17/23.
//

import Foundation
import SwiftUI

struct SwipeActionButtons {
    
    static func markUncontactedButton(action: @escaping () -> Void) -> Button<Label<Text, Image>> {
        
        return Button(action: action) {
            Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                
        }
        
      
    }
    
    static func markContactedButton(action: @escaping () -> Void) -> Button<Label<Text, Image>> {
        
        return Button(action: action) {
            Label("Mark Uncontacted", systemImage: "person.crop.circle.fill.badge.checkmark")
            
        }
    }
    
    static func deleteContactButton(action: @escaping () -> Void) -> Button<Label<Text, Image>> {
        
        return Button(action: action) {
            Label("Delete Prospect", systemImage: "trash")
                
        }
    }
    
    static func addProspectToContactButton(action: @escaping () -> Void) -> Button<Label<Text, Image>> {
        
        return Button(action: action) {
            Label("Add to Contacts", systemImage: "plus")
        }
    }

    
}

struct confirmationButton: View {
    var title: String
    var actionToPerform: () -> Void //performs an action here

    var body: some View {
        Button {
            actionToPerform()
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .padding(.horizontal,40)
                //.shadow(radius: 5)
            //more here!!
        }
        .buttonStyle(.plain)

    }
}
