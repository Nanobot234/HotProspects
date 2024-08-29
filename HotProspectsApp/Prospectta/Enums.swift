//
//  Enums.swift
//  HotProspects
//
//  Created by Nana Bonsu on 6/26/24.
//

import Foundation

///  helps to decide which sheet to present. used to avoid presentation conflicts in the meView sheet
enum ActiveSheet: Identifiable {
    case qrCode, changeEvent, linkedinInstructions, discordInstructions
    
    var id: Int {
        hashValue
    }
}
