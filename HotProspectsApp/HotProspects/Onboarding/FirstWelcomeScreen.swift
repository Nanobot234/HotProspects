//
//  FirstWelcomeScreen.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/22/24.
//

import SwiftUI

/// Screen describing the app features when the user first launches the application
///
///
struct FirstWelcomeScreen: View {
    
    var qrCodeFeature = "Scan a Prospect's QR code to save their contact information quickly and securely"
    var reminderFeature = "Set date and time reminders to contact certain prospects"
    var socialmediaFeature = "Easily share your Linkedin and Discord with others"
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Weclome to Prospecta")
                    .fontWeight(.heavy)
                    .font(.system(size: 30))
                
                
                VStack(alignment: .leading) {
                    //here is a list of the details...
                    appFeature(image: "qrcode", imageColor: Color.blue, title: "Instantly Save Contact Info", description: qrCodeFeature)
                    //two then three
                    
                    appFeature(image: "bell.badge", imageColor: Color.yellow, title: "Never Miss a Connection", description: reminderFeature)
                    
                    appFeature(image: "point.3.filled.connected.trianglepath.dotted", imageColor: Color.green, title: "Connect Online", description: socialmediaFeature)
                }
                
                Spacer()
                
                NavigationLink(destination: OnboardingUserInfoEntry()) {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 350, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(.bottom, 20)
                    
                }
            }
            
            
            
            //now the the button here to move on
            
        }
    }
        
}

struct appFeature: View {
    var image: String
    var imageColor: Color
    var title: String
    var description: String
    
    var body: some View {
           HStack(alignment: .center) {
                   HStack {
                       Image(systemName: image)
                           .font(.system(size: 50))
                           .frame(width: 50)
                           .foregroundColor(imageColor)
                           .padding()

                       VStack(alignment: .leading) {
                           Text(title).bold()
                               .fixedSize()
                       
                           Text(description)
                               .fixedSize(horizontal: false, vertical: true)
                               .font(.system(size:15))
                       }
                   }.frame(width: 300, height: 100)
           }
       }
}

struct FirstWelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        FirstWelcomeScreen()
    }
}
