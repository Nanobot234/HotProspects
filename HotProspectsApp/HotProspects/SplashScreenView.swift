//
//  SplashScreenView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 10/20/23.
//

import SwiftUI

struct SplashScreenView: View {
    
    @Environment(\.isBioAuthenticated) private var isAuthenticated
    @State var isActive: Bool = false
    @State var isFirstLaunch: Bool = false
    //here will put the envi
    
    var body: some View {
        
        
        ZStack {
            if isActive {
                if isFirstLaunch {
                    FirstWelcomeScreen()
                } else {
                    ContentView()
                }
            } else {
                Image("AppIcon")
                    .resizable()
                    .frame(width: 300, height: 300)
                Spacer()
            }
        }
        
        //now show the main view after a few seoncs
        .onAppear {
            
           // self.isFirstLaunch = self.checkIfirstLaunch()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        
    }
    
    /// Determines if this is the first user launch of the application
   
    
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
