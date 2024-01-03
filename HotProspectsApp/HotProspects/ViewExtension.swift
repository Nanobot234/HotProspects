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
    
    func hideKeyBoard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
               }
    
    //making a function for a sheet to show!
}



