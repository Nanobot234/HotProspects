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
    @AppStorage("hasFinishedOnBoarding") var userFinishedOnboarding: Bool = false
    
    @EnvironmentObject var meViewModel: MeViewModel
    
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Text("Socials")
                    .fontWeight(.heavy)
                    .font(.system(size: 30))
//                Text("Add your socials so that others can connect with you. You can also add them later in the profile section")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
            }
            .padding([.bottom], 30)
            
            //
            //text feild for the linkedin username

            
            EGTextField(text: $meViewModel.linkedinUsername)
                .setTitleText("Linkedin Username/Profile Url")
                .padding()
                .textInputAutocapitalization(.never)
               
            
            EGTextField(text: $meViewModel.discordUsername)
                .setTitleText("Discord Username")
                .padding()
                .textInputAutocapitalization(.never)
           // oAuthButton(buttonText: "Connect your Linkedin", imageString: "linkedin-app-icon", authType: "Linkedin")

           // oAuthButton(buttonText: "Connect your Discord", imageString: "discord-color-icon", authType: "Discord")
            
            //replace here

            
            Button {
                userFinishedOnboarding = true
            } label: {
                Text("Finish")
                    .foregroundColor(.white)
                    .frame(width: 350, height: 60)   // Set the size of the button first
                    .background(Color.blue)          // Then apply the background color
                            // Set the text color to white
                    .font(.headline)                 // Set the font of the button text
                    .cornerRadius(15)                // Round the corners of the button
                    .padding(.bottom, 20)            // Add padding below the button
                    .padding(.top, 40)               // Add padding above the button
            }
           

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
            .environmentObject(MeViewModel())
    }
}
