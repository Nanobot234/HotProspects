//
//  TextFeildWithToggle.swift
//  HotProspects
//
//  Created by Nana Bonsu on 12/13/23.
//

import SwiftUI

struct TextFeildWithToggle: View {
    
    @State var placeholder: String
    
    @Binding var text: String
    //include array of strings as a binding
    
    /// the index of the element that will be excluded from the contact string/
    //@Binding var exclusionIndex: Int
    // @Binding var inclusionIndex: Int
    ///  an array of bindings for the various contact info that the user can share
//    @Binding var contactPoints: [String]
    /// Indicates whether the toggle for this view was turned on or off.
    @Binding var toggleActive: Bool
    @State var updateQrCode: () -> Void
    @State var errorMessage: String = ""
    @Binding var errorPresent: Bool
    
    
    
    
    var body: some View {
        
        VStack {
            HStack {
                TextField(placeholder,text: $text)
                    .onChange(of: text) {newText in
                        
                        setErrorMessage()
                    }
                
                    .textContentType(.name)
                    .font(.title3)
                
                
                Toggle("", isOn: $toggleActive)
                    .frame(width: 60, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.red, lineWidth: 1)
                        
                        //TODO: need to make a case where you only toggle the button with text in it!! not
                    )
                    .disabled(text.isEmpty || errorMessage != "")
                    .onChange(of: toggleActive) { toogleState in
                        //the toggle is turned off
                        
                    }
                
            }
            .padding(5)
            if(errorMessage != "") {
                Text(errorMessage)
                    .foregroundColor(Color.red)
            }
            
            //this text will be the validation text, displayyng error, will need to hide it when needed
        }
        .onAppear {
           // setErrorMessage()
            loadToggleState()
            
            
        }
        
    }
    
    /// Sets   an error message based on the placeholder type of the view thats being implemented
    ///
    func setErrorMessage() {
        switch placeholder {
            
        case "Email Address":
            if(!Utilties.isValidContactPoint(text, validationType: "email") && !text.isEmpty){
                errorMessage = "Please enter a valid email address"
                errorPresent = true
            } else {
                errorMessage = ""
                //if no error previously, then mak remove the error boolean
                errorPresent = false
            }
        case "Phone Number":
            if(!Utilties.isValidContactPoint(text, validationType: "phoneNumber") && !text.isEmpty){
                errorMessage = "Please enter a valid phone number. Make sure you have no dashes between the numbers"
                errorPresent = true
            } else {
                errorMessage = ""
                errorPresent = false
            }
        default:
            errorMessage = ""
            
        }
    }
    
    ///  Loads the saved
    func loadToggleState() {
        
        switch placeholder {
        case "Email Address":
            toggleActive = UserDefaults.standard.bool(forKey: "emailToggleStatus")
            print("Email Here")
        case "Phone Number":
            toggleActive = UserDefaults.standard.bool(forKey: "phoneNumberToggleStatus")
            print("phone number is \(toggleActive.description)")
        case "LinkedIn Username":
            toggleActive = UserDefaults.standard.bool(forKey: "linkedinToggleStatus")
            print("Linkedin username is \(toggleActive.description)")
            
        case "Discord Username":
            toggleActive =  UserDefaults.standard.bool(forKey: "discordToggleStatus")
      
        default:
            print("Nope")
        }
    }
}

//struct TextFeildWithToggle_Previews: PreviewProvider {
//    
//    @State var text: String = "Hello"
//    static var previews: some View {
//        TextFeildWithToggle(placeholder: "Email Address", textType: .name, text: $text)
//    }
//}
