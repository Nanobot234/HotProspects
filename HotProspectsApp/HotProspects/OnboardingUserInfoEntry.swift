//
//  dfgv.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/15/24.
//

import SwiftUI
import CustomTextField

struct OnboardingUserInfoEntry: View {
    
    /// conditional that determines whether text will be entered by the user for this page
    @State var name = ""
    @State var emailAddress = ""
    @State var phone = ""
    @State var nameError = false
    
    @State var linkedinHandleString = ""
    var body: some View {
        
        VStack {
            
            Text("Your Contact Information")
                .fontWeight(.heavy)
                .font(.system(size: 30))
            
            
            //basic details you will share with a prospect
            
            
            EGTextField(text: $name)
                .setTitleText("Your Name")
                .setFocusedBorderColor(.blue)
                .setFocusedBorderColorEnable(true)
                .padding()
            
            //            TextField("Your name", text: $name)
            //                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            EGTextField(text: $emailAddress)
                .setTitleText("Your Email Address")
                .setFocusedBorderColor(.blue)
                .setFocusedBorderColorEnable(true)
                .padding()
            
            
            EGTextField(text: $phone)
                .setTitleText("Your Name")
                .setFocusedBorderColor(.blue)
                .setFocusedBorderColorEnable(true)
                .padding()
            
            NavigationLink(destination: OnboardingUserInfoEntry()) {
                Text("Next")
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

struct dfgv_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingUserInfoEntry()
    }
}
