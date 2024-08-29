//
//  dfgv.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/15/24.
//

import SwiftUI
import CustomTextField

struct OnboardingUserInfoEntry: View {
    
    @EnvironmentObject var meViewModel: MeViewModel
    ///
    enum FocusFeild: Hashable {
        case name
        case phoneNumber
        case emailAddress
    }
    
    //@State var name = ""
   // @State var meViewModel.emailAddress = ""
    //@State var phone = ""
    
    @State private var nameError = true
    @State var nameErrorMessage = ""
    
    @State var emailError = false
    @State var emailErrorMessage = ""
    
    @State var phoneNumberError = false
    @State var phoneErrorMessage = ""
    //@State var emailErrorMessage =
    
    @State var linkedinHandleString = ""
    
    @State private var buttonIsDisabled = false
    
    @FocusState private var focusField: FocusFeild?
    var body: some View {
        
        VStack(spacing: 10) {
            
            Text("Basic Info")
                .fontWeight(.heavy)
                .font(.system(size: UIScreen.main.bounds.width < 375 ? 24 : 30)) // Adjust font size for smaller screens
                               .padding(.top, UIScreen.main.bounds.width < 375 ? 20 : 40)
            
//            Text("Your name, email,and phone number will be shared with prospects that you choose")
//                .font(.subheadline)
//                .foregroundStyle(Color.secondary)
            
            
            //basic details you will share with a prospect
            
            VStack{
                EGTextField(text: $meViewModel.name)
                    .setTitleText(" Name")
                    .setFocusedBorderColor(.blue)
                    .setFocusedBorderColorEnable(true)
                    .keyboardType(.namePhonePad)
                    .focused($focusField, equals: .name)
                    .onChange(of: meViewModel.name) { _ in
                        validateName()
                        print("NameEror: \(nameError)")
                    }
                
                if nameError && focusField == .name {
                    Text(nameErrorMessage)
                        .foregroundStyle(.red)
                }
            }
                      
                .padding()
            

            VStack {
                EGTextField(text: $meViewModel.emailAddress)
                    
                    .setTitleText("Email Address")
                    .setFocusedBorderColor(.blue)
                    .setFocusedBorderColorEnable(true)
                    .keyboardType(.emailAddress)
                    .focused($focusField, equals: .emailAddress)
                    .padding()
                    .onChange(of: meViewModel.emailAddress) { _ in
                        validateEmailAddress()
                        print("EmailError: \(emailError)")
                    }
                
                if emailError && focusField == .emailAddress {
                    Text(emailErrorMessage)
                        .foregroundStyle(.red)
                }
                
            }
                
               
            VStack {
                EGTextField(text: $meViewModel.phoneNumber)
                    .setTitleText("Your Phone Number")
                    .setFocusedBorderColor(.blue)
                    .setFocusedBorderColorEnable(true)
                    .keyboardType(.phonePad)
                    .focused($focusField, equals: .phoneNumber)
                    .padding()
                    .onChange(of: meViewModel.phoneNumber) { _ in
                        validatephoneNumber()
                        print("PhoneNumberError \(phoneNumberError)")
                    }
                
                if phoneNumberError && focusField == .phoneNumber {
                    Text(phoneErrorMessage)
                        .foregroundStyle(.red)
                }
            }
            
            
            Button {
                          
                      } label: {
                          NavigationLink(destination: SocialLoginScreen()) {
                              Text("Continue")
                                  .foregroundColor(.white)
                                  .font(.headline)
                                  .frame(width: 350, height: 60)
                                  .background(buttonIsDisabled ? Color.gray: Color.blue)
                                  .cornerRadius(15)
                                  .padding(.bottom, 20)
                                  .padding(.top,40)
                              
                          }
                      }
                      .buttonStyle(PlainButtonStyle())
                      .disabled(buttonIsDisabled)
            
            
        }
        .onChange(of: focusField, perform: { _ in
            setErrorMessage()
        })
       
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
        if meViewModel.name.isEmpty {
            nameErrorMessage = "Please enter your name"
            buttonIsDisabled = true
            nameError = true
        } else {
            nameErrorMessage = ""
            nameError = false
            buttonIsDisabled = false
            
        }
    }
    
    func validateEmailAddress() {
        if(Utilties.isValidContactPoint(meViewModel.emailAddress, validationType: "email")){
            emailErrorMessage = ""
                emailError = false
            buttonIsDisabled = false
        } else if(!Utilties.isValidContactPoint(meViewModel.emailAddress, validationType: "email") && !meViewModel.emailAddress.isEmpty){
            emailErrorMessage = "Please enter a valid email address"
            //if no error previously, then mak remove the error boolean
               emailError = true
            buttonIsDisabled = true
            
        }

    }
    
    func validatephoneNumber() {
        if(Utilties.isValidContactPoint(meViewModel.phoneNumber, validationType: "phoneNumber")){
           phoneErrorMessage = ""
            phoneNumberError = false
            buttonIsDisabled = false       
        } else if(!Utilties.isValidContactPoint(meViewModel.phoneNumber, validationType: "phoneNumber") && !meViewModel.phoneNumber.isEmpty) {
            phoneErrorMessage = "Please enter a valid phone number. Make sure you have no dashes between the numbers"
                phoneNumberError = true
            buttonIsDisabled = true
        }
    }
    
}

struct dfgv_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingUserInfoEntry()
    }
}
