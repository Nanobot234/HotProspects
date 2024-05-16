//
//  TextFeildWithToggle.swift
//  HotProspects
//
//  Created by Nana Bonsu on 12/13/23.
//

import SwiftUI

struct TextFeildWithToggle: View {
    
    var placeholder: String
    
    @Binding var text: String
    //include array of strings as a binding
    
    /// the index of the element that will be excluded from the contact string/
    //@Binding var exclusionIndex: Int
    // @Binding var inclusionIndex: Int
    @Binding var contactPoints: [Binding<String>]
    @Binding var feildWasToggled: Bool
    @State private var toggleActive: Bool = true
    var updateQrCode: () -> Void
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
                    .disabled(text.isEmpty)
                    .onChange(of: toggleActive) { toogleState in
                        if(!toogleState){
                            
                            contactPoints = contactPoints.filter({$0.wrappedValue != text}) //this filters out the currentText in the contactPoints array.
                            updateQrCode()
                            feildWasToggled = false
                            
                        } else {
                            feildWasToggled = true
                            switch placeholder {
                            case "Email Address":
                                contactPoints.insert($text, at: 1)
                                updateQrCode()
                            case "Phone Number":
                                contactPoints.insert($text, at: 2)
                                updateQrCode()
                            case "LinkedIn Username":
                                contactPoints.insert($text, at: 3)
                                updateQrCode()
                            case "Discord Username":
                                contactPoints.insert($text, at: 4)
                                updateQrCode()
                            default:
                                contactPoints.insert($text, at: 1)
                                updateQrCode() //runs the function that will be passed in!!
                            }
                        }
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
            setErrorMessage()
        }
            
        }
    
    /// Sets   an error message based on the placeholder type of the view thats being implemented
    /// 
    func setErrorMessage() {
        switch placeholder {
        case "Email Address":
            if(!Utilties.isValidContactPoint(text, validationType: "email")){
                errorMessage = "Please enter a valid email address"
                    errorPresent = true
            } else {
                errorMessage = ""
                //if no error previously, then mak remove the error boolean
               
                    errorPresent = false
                
            }
        case "Phone Number":
            if(!Utilties.isValidContactPoint(text, validationType: "phoneNumber")){
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
    
    
    }


//struct TextFeildWithToggle_Previews: PreviewProvider {
//    
//    @State var text: String = "Hello"
//    static var previews: some View {
//        TextFeildWithToggle(placeholder: "Email Address", textType: .name, text: $text)
//    }
//}
