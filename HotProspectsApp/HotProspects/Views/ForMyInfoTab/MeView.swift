//
//  MeView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/11/23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import PhotosUI

struct MeView: View {
    
    //@EnvironmentObject private var viewModel:RowModel
    
    @State private var name = ""
    @State private var emailAddress = ""
    @State private var phoneNumber = ""
    @State private var contactPoints = [Binding<String>]()
    
    @EnvironmentObject var eventLocation: EventLocation
        
    @State private var contactPointsInitialized: Bool = false //continue!
  //   @State var copyOfContacts = [String]()
    @State private var qrCode: UIImage? = UIImage()
    @State var emailWasToggled: Bool = true //toggled on initially
    @State var phoneNumWasToggled: Bool = true
    @State var indexToExclude:Int = 30
    @State var indexToInclude:Int = 30
    @State var showingQRCodeSheet = false
    /// Alerts if the user has made an error in contact info.
    @State var errorInEmail = false
    @State var errorinPhoneNum = false
    let context = CIContext()
    
    ///Generate the QR image
    let filter = CIFilter.qrCodeGenerator()
    
    
    init() {
       
    }
//have a button that basically is activated when something is toggled, then will run the code conditionll
    var body: some View {
        NavigationView {
            Form {
                
                CurrentLocationView() // textFeild and button to change the current event of the user.
      
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
                        TextFeildWithToggle(placeholder: "Email Address",textType: .emailAddress, text: $emailAddress, contactPoints: $contactPoints, feildWasToggled: $emailWasToggled, updateQrCode: updateCode, errorPresent: $errorInEmail)
                    } header: {
                        Text("Email Address")
                    } footer: {
                            Text(emailWasToggled == true ? "Prospects  can now see your email address when they scan your QR code" : "Prospects will not see your email address when they scan your QR code")
                                .font(.title2)
                        
                    }
                    .headerProminence(.increased)
                    
                    Section {
                        TextFeildWithToggle(placeholder: "Phone Number",textType: .telephoneNumber, text: $phoneNumber, contactPoints: $contactPoints, feildWasToggled: $phoneNumWasToggled, updateQrCode: updateCode, errorPresent: $errorinPhoneNum)
                    } header: {
                        Text("Phone Number")
                    } footer: {
                            Text(phoneNumWasToggled == true ? "Prospects  can now see your phone number when they scan your QR code" : "Prospects will not see your phone number  when they scan your QR code")
                                .font(.title2)
                        }
                    
                    .headerProminence(.increased)
                
                //Linkedin
                //will haave to make a textFeild with first text, part of url, then more
                
                
                    //ok so when finished editing text view, and change toggle want to which toggle then exclude it

                //TODO: look into linkedin API, getting linkedin username
                // TODO: possibly other socials as well!
          
         
            }
            .background(
                Color.blue.opacity(1.0).blur(radius: showingQRCodeSheet ? 2.0:0)
            )
            
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
            
            //sheet for the QR oe
            .sheet(isPresented: $showingQRCodeSheet) {
                QRCodeView(qrCodeImage: qrCode,isSharingEmail: $emailWasToggled,isSharingPhoneNum: $phoneNumWasToggled)
                    .presentationDetents([.fraction(0.7)])
            }
            
            .sheet(isPresented: $eventLocation.changeEvent) {
                UserAndProspectLocationView(addReasonMessage:"userLocationUpdate")
                    .presentationDetents([.fraction(0.5 )])
            }
            
            .toolbar {
                
                toolbarButton("My QR Code", systemImage: "") {
                    showingQRCodeSheet = true
                }
            }
            
            //when name state variable changes,save the name to local storage and update the QRCode
            .onChange(of: name, perform: { newName in
               // contactPoints[0].wrappedValue = newName
                UserDefaults.standard.set(newName, forKey: "users_name")
                updateCode()
                
                
            })
            //when emailAddress state variable changes,save the name to local storage and update the QRCode
            .onChange(of: emailAddress, perform: { newEmail in
                UserDefaults.standard.set(newEmail, forKey: "users_email")
                updateCode()
                
            })
            
            //when phone Number state variable changes,save the name to local storage and update the QRCode
            .onChange(of: phoneNumber, perform: { newPhone in
                UserDefaults.standard.set(newPhone, forKey: "users_phone")
                updateCode()
            })
            
            .onChange(of: errorInEmail, perform: { _ in updateCode()
                print("Error present in email \(errorInEmail)")
            })
            
            .onChange(of: errorinPhoneNum, perform: { _ in updateCode()
                print("Error present in phone number \(errorinPhoneNum)")
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
        
        //If there is an error in the contact Detailss then set the QRcode to nil
        guard errorInEmail == false && errorinPhoneNum == false else {
            qrCode = nil
            return
        }

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
                    return qrCode!
                }
            }

            return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
            .environmentObject(EventLocation())
    }
}

