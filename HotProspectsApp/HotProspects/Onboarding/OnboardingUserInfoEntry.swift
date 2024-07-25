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
    ///
    enum FocusFeild: Hashable {
        case name
        case phoneNumber
        case emailAddress
    }
    
    @State var name = ""
    @State var emailAddress = ""
    @State var phone = ""
    
    @State var nameError = false
    @State var nameErrorMessage = ""
    
    @State var emailError = false
    @State var emailErrorMessage = ""
    
    @State var phoneNumberError = false
    @State var phoneErrorMessage = ""
    //@State var emailErrorMessage =
    
    @State var linkedinHandleString = ""
    
    
    @FocusState private var focusField: FocusFeild?
    var body: some View {
        
        VStack {
            
            Text("Your Contact Information")
                .fontWeight(.heavy)
                .font(.system(size: 30))
            
            Text("You contact information will be shared with prospects that you choose")
                .font(.subheadline)
            
            
            //basic details you will share with a prospect
            
            VStack{
                EGTextField(text: $name)
                    .setTitleText(" Name")
                    .setFocusedBorderColor(.blue)
                    .setFocusedBorderColorEnable(true)
                    .focused($focusField, equals: .name)
                    .onChange(of: name) { _ in
                        validateName()
                    }
                
                if nameError && focusField == .name {
                    Text(emailErrorMessage)
                        .foregroundStyle(.red)
                }
            }
                      
                .padding()
            

            VStack {
                EGTextField(text: $emailAddress)
                    .setTitleText("Email Address")
                    .setFocusedBorderColor(.blue)
                    .setFocusedBorderColorEnable(true)
                    .focused($focusField, equals: .emailAddress)
                    .padding()
                    .onChange(of: emailAddress) { _ in
                        validateEmailAddress()
                    }
                
                if emailError && focusField == .emailAddress {
                    Text(emailErrorMessage)
                        .foregroundStyle(.red)
                }
                
            }
                
               
            VStack {
                EGTextField(text: $phone)
                    .setTitleText("Your Phone Number")
                    .setFocusedBorderColor(.blue)
                    .setFocusedBorderColorEnable(true)
                    .focused($focusField, equals: .phoneNumber)
                    .padding()
                    .onChange(of: phone) { _ in
                        validatephoneNumber()
                    }
                
                if phoneNumberError && focusField == .phoneNumber {
                    Text(phoneErrorMessage)
                        .foregroundStyle(.red)
                }
            }
            
            NavigationLink(destination: SocialLoginScreen()) {
                Text("Continue")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(width: 350, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .padding(.bottom, 20)
                    .padding(.top,40)
                    .disabled(phoneNumberError && nameError && emailError)
            }
        }
        .onChange(of: focusField, perform: { _ in
            setErrorMessage()
        })
       
        .onDisappear {
            saveUserInfoIntoUserDefaults()
        }
    }
    
    func saveUserInfoIntoUserDefaults() {
        
        UserDefaults.standard.set(name, forKey: "users_name")

        UserDefaults.standard.set(emailAddress, forKey: "users_email")
        
        UserDefaults.standard.set(phone, forKey: "users_phone")
        
    }
    
    
    
    func setErrorMessage() {
        switch focusField {
        case .name:
          validateName()
        case .emailAddress:
          validateEmailAddress()
            
        case .phoneNumber:
         validatephoneNumber()
        default:
            print("Good")
            
        }
    }
    
    func validateName() {
        if name.isEmpty {
            nameErrorMessage = "Please enter your name"
            nameError = true
        } else {
            nameErrorMessage = ""
            nameError = false
        }
    }
    
    func validateEmailAddress() {
        if(Utilties.isValidContactPoint(emailAddress, validationType: "email")){
            emailErrorMessage = ""
                emailError = false
        } else {
            emailErrorMessage = "Please enter a valid email address"
            //if no error previously, then mak remove the error boolean
               emailError = true
            
        }

    }
    
    func validatephoneNumber() {
        if(Utilties.isValidContactPoint(phone, validationType: "phoneNumber")){
           phoneErrorMessage = ""
            phoneNumberError = false
            
        } else {
            phoneErrorMessage = "Please enter a valid phone number. Make sure you have no dashes between the numbers"
                phoneNumberError = true
            
        }
    }
    
}

struct dfgv_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingUserInfoEntry()
    }
}
