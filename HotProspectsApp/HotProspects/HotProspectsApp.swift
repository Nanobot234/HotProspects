//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Nana Bonsu on 8/28/23.
//

import SwiftUI
//import OAuthSwift
//import Supabase

@main
struct HotProspectsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .onAppear {
                   setOrientationLock()
                }
                }
       
        }
    }

func setOrientationLock() {
      let supportedOrientations = UIInterfaceOrientationMask.portrait
      let key = "orientationLock"
      NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: supportedOrientations)
  }


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
