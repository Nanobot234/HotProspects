//
//  MessageViewController.swift
//  HotProspects
//
//  Created by Nana Bonsu on 5/11/24.
//

import Foundation
import SwiftUI
import MessageUI

struct MessageView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    var messageBody: String
    var phoneNumber: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let messageComposeViewController = MFMessageComposeViewController()
        messageComposeViewController.messageComposeDelegate = context.coordinator
        messageComposeViewController.recipients = ["recipientPhoneNumber"]
        messageComposeViewController.body = messageBody
        return messageComposeViewController
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
    }
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageView
        
        init(parent: MessageView) {
            self.parent = parent
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            parent.isShowing = false
        }
    }
}
