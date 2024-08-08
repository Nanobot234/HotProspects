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
    @StateObject var meViewModel =  MeViewModel()
    //here will put the envi
    @AppStorage("hasFinishedOnBoarding") var userFinishedOnboarding: Bool = false
    //variable here that will determine if info was filled for the first time, will be used to set value!
    
    var body: some View {
        
        
        ZStack {
            if isActive {
                if !userFinishedOnboarding {
                    FirstWelcomeScreen()
                } else {
                    ContentView()
                }
            } else {
                Image("PropectaAppIcon")
                    .resizable()
                    .frame(width: 300, height: 300)
                Spacer()
            }
        }
        .environmentObject(meViewModel)
        
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

//making a boolean that shows
