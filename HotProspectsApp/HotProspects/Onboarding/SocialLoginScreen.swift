//
//  SocialButtons.swift
//  HotProspects
//
//  Created by Nana Bonsu on 3/27/24.
//

import SwiftUI
import CustomTextField

/// Displays various social buttons for users to connect to the app.
struct SocialLoginScreen: View {
    //have some bindings to the screen when  the user logs in!
    @State private var linkedinUsername = ""
    @State private var discordUsername = ""
    
    var body: some View {
        VStack {
            
            Text("Socials")
                .font(.largeTitle)
            Text("Enter your username for the following social networks so that others can connect with you. You can also add them later in the profile section")
                .font(.subheadline)
            
            //
            //text feild for the linkedin username
         
            
            
            EGTextField(text: $linkedinUsername)
                .setTitleText("Your Linkedin Username")
                .padding()
               
            
            EGTextField(text: $discordUsername)
                .setTitleText("Your Discord Username")
                .padding()
           // oAuthButton(buttonText: "Connect your Linkedin", imageString: "linkedin-app-icon", authType: "Linkedin")

           // oAuthButton(buttonText: "Connect your Discord", imageString: "discord-color-icon", authType: "Discord")
            
            //replace here
            NavigationLink(destination: ContentView()) {
                Text("Continue")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding(.bottom, 20)
                    .padding(.top,40)
            }
            
        }
        .onChange(of: linkedinUsername) { updatedLinkedinUsernmae in
            UserDefaults.standard.set(updatedLinkedinUsernmae, forKey: "linkedin_UserName")
        }
        
        .onChange(of: discordUsername) { updatedDiscord in
            UserDefaults.standard.set(discordUsername, forKey: "discord_username")
        }
      
    }
}


//struct oAuthButton: View {
//
//    @Environment(\.colorScheme) var appColor
//
//
//
//    var buttonText: String
//    var imageString: String
//    var authType: String
//
//    var body: some View {
//
//        Button(action: siginIn) {
//            Text(buttonText)
//                .foregroundColor(appColor == .dark ? .white : .black)
//                .frame(maxWidth: .infinity)
//                .padding(.vertical,8)
//                .background(alignment: .leading) {
//                    Image(imageString)
//                        .resizable()
//                        .frame(width: 40, alignment: .center)
//
//                }
//        }
//        .padding([.horizontal,.vertical],20)
//        .buttonStyle(.bordered)
//    }
//
//
//    func siginIn() {
//        switch authType {
//        case "Google":
//
//            Task {
//                do {
////                    let currentUser = try await authModel.signInWithGoogle()
////                    self.currentUser = currentUser
//                } catch {
//                    print("Error:\(error.localizedDescription)")
//                }
//            }
//        case "Apple":
//            print("Deez")
//        default:
//            break
//        }
//    }
//
//}

struct SocialLoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        SocialLoginScreen()
    }
}
