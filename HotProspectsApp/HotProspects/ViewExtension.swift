//
//  ViewExtension.swift
//  HotProspects
//
//  Created by Nana Bonsu on 10/26/23.
//

import Foundation
import SwiftUI

extension View {
    
    func toolbarButton(_ title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .labelStyle(.titleAndIcon)
        }
    }
    
    //making a function for a button
}



