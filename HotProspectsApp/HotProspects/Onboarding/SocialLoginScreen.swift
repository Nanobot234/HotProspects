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
                .setTitleText("Linkedin username or Profile Url")
                .padding()
                .textInputAutocapitalization(.never)
               
            
            EGTextField(text: $meViewModel.discordUsername)
                .setTitleText("Discord Username")
                .padding()
                .textInputAutocapitalization(.never)
           // oAuthButton(buttonText: "Connect your Linkedin", imageString: "linkedin-app-icon", authType: "Linkedin")

           // oAuthButton(buttonText: "Connect your Discord", imageString: "discord-color-icon", authType: "Discord")
            
            //replace here

            
            Button("Finish") {
                userFinishedOnboarding = true
            }
                .frame(width: 350, height: 60)
                .foregroundColor(.white)
                .font(.headline)
                .background(Color.blue)
                .cornerRadius(15)
                .padding(.bottom, 20)
                .padding(.top,40)
            
            
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
