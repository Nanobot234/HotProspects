//
//  SplashScreenView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 10/20/23.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State  var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if(isActive) {
                ContentView()
            } else {
                Image("LocationChatLogo")
                    .resizable()
                    .frame(width: 300, height: 300)
                Spacer()
            }
        }
        
        //now show the main view after a few seoncs
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
