//
//  TextFeildWithToggle.swift
//  HotProspects
//
//  Created by Nana Bonsu on 12/13/23.
//

import SwiftUI

struct TextFeildWithToggle: View {
    
    var placeholder: String
    var textType: UITextContentType
    @Binding var text: String
    //include array of strings as a binding
    
    /// the index of the element that will be excluded from the contact string/
    //@Binding var exclusionIndex: Int
    // @Binding var inclusionIndex: Int
    @Binding var contactPoints: [Binding<String>]
    @Binding var feildWasToggled: Bool
    @State private var toggleActive: Bool = true
    var updateQrCode: () -> Void
    
    
    var body: some View {
        
        HStack {
            TextField(placeholder,text: $text)
                .textContentType(.name)
                .font(.title3)
                
            Toggle("", isOn: $toggleActive)
                .frame(width: 60, height: 30)
                .background(
                               RoundedRectangle(cornerRadius: 8)
                                   .stroke(Color.red, lineWidth: 1)
                           )
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
                                //   inclusionIndex = 1
                                //contactPoints[2].wrappedValue = text
                                
                                contactPoints.insert($text, at: 2)
                               // contactPoints.append($text)
                                updateQrCode()
                            default:
                                //  inclusionIndex = 0
                             //   contactPoints[1].wrappedValue = text
                                
                                contactPoints.insert($text, at: 1)
                                updateQrCode() //runs the function that will be passed in!!
                            }
                        }
                    }
                }
                .padding(5)
            
        }
        
    }



//struct TextFeildWithToggle_Previews: PreviewProvider {
//    
//    @State var text: String = "Hello"
//    static var previews: some View {
//        TextFeildWithToggle(placeholder: "Email Address", textType: .name, text: $text)
//    }
//}
