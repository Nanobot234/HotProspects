//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Nana Bonsu on 8/28/23.
//

import SwiftUI
//import OAuthSwift

@main
struct HotProspectsApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .onOpenURL { url in
                    

                    }
                }
        }
    }

