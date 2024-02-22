//
//  SocialConnections.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/22/24.
//

import SwiftUI
//import OAuthSwift

/// Allow users to connect various relevant social accounts.
struct SocialConnections: View {
    
    @ObservedObject var oAuthMoel: OAuthViewModel
    
    var body: some View {
        
        //Button having linkedin,
        VStack {
         //   socialButton(buttonText: "Connect with LinkedIn", buttonImage: "linkedin-app-icon")
            
           // socialButton(buttonText: "Connect with Discord", buttonImage: "discord-color-icon")
            
            
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
    }
    
    
}

struct socialButton: View {
   
    @ObservedObject var oAuthModel: OAuthViewModel
    
    var buttonText: String
    var buttonImage: String
   // var buttonType: String
    var linkedInString = URL(string:"Nana-Bonsu.HotProspects://oauth-callback/linkedin")
  //  var state = generateState(withLength: 20)
    
    var body: some View {
        Button {
//             if(buttonType == "linkedin"){
//                 oAuthModel.oauthswift.authorize(withCallbackURL: linkedInString, scope: <#T##String#>, state: state) { result in
//                     switch result {
//                     case .success(let (credential, _, _)):
//                         credential.oauthToken
//                     }
//                 }
//             }
        } label: {
            Label {
                Text(buttonText)
                    .foregroundColor(.white)
            } icon: {
                //Lin
                Image(buttonImage)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue) //Sets color of Linkedin
            }

        }
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        
    }
    
    
}

//social button
//
//struct SocialConnections_Previews: PreviewProvider {
//    static var previews: some View {
//        SocialConnections()
//    }
//}
