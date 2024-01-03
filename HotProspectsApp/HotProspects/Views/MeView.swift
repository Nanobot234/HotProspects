//
//  MeView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/11/23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    
    //@EnvironmentObject private var viewModel:RowModel
    
    @State private var name = ""
    @State private var emailAddress = ""
    @State private var phoneNumber = ""
    @State private var contactPoints = [Binding<String>]()
        
    @State private var contactPointsInitialized: Bool = false //continue!
  //   @State var copyOfContacts = [String]()
    @State private var qrCode = UIImage()
    @State var emailWasToggled: Bool = true //toggled on initially
    @State var phoneNumWasToggled: Bool = true
    @State var indexToExclude:Int = 30
    @State var indexToInclude:Int = 30
    
    let context = CIContext()
    
    ///Generate the QR image
    let filter = CIFilter.qrCodeGenerator()
    
    
    init() {
       
    }
//have a button that basically is activated when something is toggled, then will run the code conditionll
    var body: some View {
        NavigationView {
            Form {
                    
                    Section {
                        TextField("Name", text: $name)
                            .textContentType(.name)
                            .font(.title3)
                    } header: {
                        Text("Name")
                    }
                    .headerProminence(.increased)
     
                    //Sections with header and footer
                    
                    Section {
                        TextFeildWithToggle(placeholder: "Email Address",textType: .emailAddress, text: $emailAddress, contactPoints: $contactPoints, feildWasToggled: $emailWasToggled, updateQrCode: updateCode)
                    } header: {
                        Text("Email Address")
                    } footer: {
                        let statusMessage = emailWasToggled == true ? "Sharing Active" : "Not Sharing"
                        VStack {
                            Text("Status: " + statusMessage)
                                .font(.title3)
                            Text(emailWasToggled == true ? "Prospects  can now see your email address when they scan your QR code" : "Prospects will not see your email address when they scan your QR code")
                        }
                    }
                    .headerProminence(.increased)
                    
                    Section {
                        TextFeildWithToggle(placeholder: "Phone Number",textType: .telephoneNumber, text: $phoneNumber, contactPoints: $contactPoints, feildWasToggled: $phoneNumWasToggled, updateQrCode: updateCode)
                    } header: {
                        Text("Phone Number")
                    } footer: {
                        let statusMessage = phoneNumWasToggled == true ? "Sharing Active" : "Not Sharing"
                        VStack(alignment: .leading) {
                            Text("Status: " + statusMessage)
                                .font(.title3)
                            Text(phoneNumWasToggled == true ? "Prospects  can now see your phone number when they scan your QR code" : "Prospects will not see your phone number  when they scan your QR code")
                        }
                    }
                
                
                    //ok so when finished editing text view, and change toggle want to which toggle then exclude it
                    
                  
               
                
                //TODO: look into linkedin API, getting linkedin username
                // TODO: possibly other socials as well!
//                Section {
//                    (TextField)
//                }
                Section(header: Text("My QR Code").bold()) {
                    HStack {
                        Image(uiImage: qrCode)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .contextMenu {
                                Button {
                                    
                                    let imageSaver = ImageSaver()
                                    imageSaver.writeToPhotoAlbum(image: qrCode)
                                } label: {
                                    Label("Save to Photos", systemImage: "square.and.arrow.down")
                                }
                            }
                        
                        Image(systemName: "square.and.arrow.down")
                    }
                }
                
                CurrentLocationView()
         
            }
            .navigationTitle("My Info")
            .onAppear {
                
                updateCode()
                
                if !contactPointsInitialized {
                    contactPoints = [$name,$emailAddress,$phoneNumber]
                    print(contactPoints.count)
                }
                
                contactPointsInitialized = true
                
                name = UserDefaults.standard.string(forKey: "users_name") ?? ""
                emailAddress = UserDefaults.standard.string(forKey: "users_email") ?? ""
                phoneNumber = UserDefaults.standard.string(forKey:"users_phone") ?? ""
            }
            
            
//            .onChange(of: indexToExclude, perform: {newIndex in
//                //add to excluded array,
//
//                let target = contactPoints[newIndex]
//           //     copyOfContacts[newIndex] = target
//                contactPoints[newIndex] = ""
//            })
//            .onChange(of: indexToInclude, perform: { newIndex in
//              //  contactPoints[newIndex] = copyOfContacts[newIndex]
//                //here run
//
//            })
//            .onChange(of: contactPoints, perform: { _ in
//                updateCode() //updates code when any of its elements cahnges
//            })
            //TODO: When array changes, have condition to update the code
            .onChange(of: name, perform: { newName in
               // contactPoints[0].wrappedValue = newName
                UserDefaults.standard.set(newName, forKey: "users_name")
                updateCode()
                
                
            })
            .onChange(of: emailAddress, perform: { newEmail in
                UserDefaults.standard.set(newEmail, forKey: "users_email")
                print("Saved email now" + UserDefaults.standard.string(forKey: "users_email")!)
                updateCode()
                
            })
            .onChange(of: phoneNumber, perform: { newPhone in
                UserDefaults.standard.set(newPhone, forKey: "users_phone")
                updateCode()
            })
            .onDisappear(
                perform: saveUserInfo
            )
        }
    }
    
    /// updates the  generated QR code image based on the users name, email, and phoneNumber.
    ///
    /// THe qrCode image is generated by calling the `generateCode` method. The view constanly calls this function as the name , email, and address parametrs change
    func updateCode()
    {
        var QRString = ""
            for index in 0..<contactPoints.count {
                    QRString.append(contactPoints[index].wrappedValue + "\n")
            }
 
        qrCode = generateQRCode(from: QRString)

    }
    
  
   
    
    func saveUserInfo() {
        UserDefaults.standard.set(name, forKey: "users_name")
        UserDefaults.standard.set(emailAddress, forKey: "users_email")
        UserDefaults.standard.set(phoneNumber, forKey: "users_phone")
    }
    
    /// Generates the QR code
    /// - Parameter string: the user's contact information
    /// - Returns: a `UIImage` that represents the QR code or an empty `UIImage` if there is an error
    func generateQRCode(from string:String) -> UIImage {
        filter.message = Data(string.utf8) // puts the filter inside

            if let outputImage = filter.outputImage {
                if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                    qrCode = UIImage(cgImage: cgimg) //cashing it to be saved
                    return qrCode
                }
            }

            return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}

