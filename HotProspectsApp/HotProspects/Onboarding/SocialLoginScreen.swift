//
//  SocialButtons.swift
//  HotProspects
//
//  Created by Nana Bonsu on 3/27/24.
//

import SwiftUI

/// Displays various social buttons for users to connect to the app.
struct SocialLoginScreen: View {
    //have some bindings to the screen when  the user logs in!
    var body: some View {
        VStack {
            
            Text("Socials")
                .font(.largeTitle)
            Text("Connect your social accounts now to share your profile information with prospects. You can also do this later in your profile")
                .font(.title3)
            
            //
            
         
            oAuthButton(buttonText: "Connect your Linkedin", imageString: "linkedin-app-icon", authType: "Linkedin")

            oAuthButton(buttonText: "Connect your Discord", imageString: "discord-color-icon", authType: "Discord")
            
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
    }
}


struct oAuthButton: View {
    
    @Environment(\.colorScheme) var appColor
    


    var buttonText: String
    var imageString: String
    var authType: String
    
    var body: some View {
        
        Button(action: siginIn) {
            Text(buttonText)
                .foregroundColor(appColor == .dark ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.vertical,8)
                .background(alignment: .leading) {
                    Image(imageString)
                        .resizable()
                        .frame(width: 40, alignment: .center)
                        
                }
        }
        .padding([.horizontal,.vertical],20)
        .buttonStyle(.bordered)
    }
    
    
    func siginIn() {
        switch authType {
        case "Google":
            
            Task {
                do {
//                    let currentUser = try await authModel.signInWithGoogle()
//                    self.currentUser = currentUser
                } catch {
                    print("Error:\(error.localizedDescription)")
                }
            }
        case "Apple":
            print("Deez")
        default:
            break
        }
    }
    
}

struct SocialLoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        SocialLoginScreen()
    }
}
