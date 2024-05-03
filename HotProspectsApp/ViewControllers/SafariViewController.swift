//
//  SafariViewController.swift
//  HotProspects
//
//  Created by Nana Bonsu on 4/23/24.
//

import Foundation
import SwiftUI
import SafariServices


struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No update needed
    }
}


