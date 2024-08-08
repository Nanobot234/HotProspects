//
//  ActivityViewController.swift
//  HotProspects
//
//  Created by Nana Bonsu on 7/25/24.
//

import Foundation
import UIKit
import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        
        controller.modalPresentationStyle =  .pageSheet
        
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
     
        controller.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                   self.isPresented = false
               }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need to update
    }
}
