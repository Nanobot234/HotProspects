//
//  MeView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/11/23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import PhotosUI
import BetterSafariView
//import Supabase

struct MeView: View {
    
    //@EnvironmentObject private var viewModel:RowModel
    
    @StateObject var meViewModel =  MeViewModel()
   
    ///  Will be used as a copy of the name of the user. This copy will be manippluated and used to display the users information in the QR code.
    
    
    @State private var contactPoints = [Binding<String>]()
    
    @EnvironmentObject var eventLocation: EventLocation
    
    @State private var contactPointsInitialized: Bool = false //continue!
    //   @State var copyOfContacts = [String]()
    @State var qrCode: UIImage? = UIImage()
    
    @State var emailWasToggled: Bool = true //toggled on initially
    @State var phoneNumWasToggled: Bool = true
    @State var linkedInUsernameWasToggled: Bool = true
    @State var discordUsernameWasToggled: Bool = true
    @State var indexToExclude:Int = 30
    @State var indexToInclude:Int = 30
    @State var showingQRCodeSheet = false
    
    @State var showingDiscordInstructions = false
    @State var showingLinkedinInstructions = false
    /// Alerts if the user has made an error in contact info.
    @State var errorInEmail = false
    @State var errorinPhoneNum = false
    @State var errorInLinkedin = false
    @State var errorInName = false
    
    @State private var startingWebAuthforLinkedin = false
    @State private var startingWebAuthforDiscord = false
    
    @State private var activeSheet: ActiveSheet?
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    ///Generate the QR image
    let filter = CIFilter.qrCodeGenerator()
    let context = CIContext()

    //have a button that basically is activated when something is toggled, then will run the code conditionll
    var body: some View {
        NavigationView {
            Form {
                
                CurrentLocationView(activeSheet: $activeSheet) // textFeild and button to change the current event of the user.
                
                Section {
                    VStack {
                        TextField("Name", text: $meViewModel.name)
                            .textContentType(.name)
                            .font(.title3)
                        
                        if(meViewModel.name.isEmpty){
                            Text("Please enter your name")
                                .foregroundStyle(Color.red)
                        }
                    }
                } header: {
                    Text("Name")
                }
                .headerProminence(.increased)
                
                //Sections with header and footer
                
                Section {
                    TextFeildWithToggle(placeholder: "Email Address", text: $meViewModel.emailAddress, toggleActive:$emailWasToggled, updateQrCode: updateCode, errorPresent: $errorInEmail)
                } header: {
                    Text("Email Address")
                } footer: {
                    Text(emailWasToggled == true ? "Prospects  can now see your email address when they scan your QR code" : "Prospects will not see your email address when they scan your QR code")
                    
                }
                .headerProminence(.increased)
                
                Section {
                    TextFeildWithToggle(placeholder: "Phone Number", text: $meViewModel.phoneNumber, toggleActive: $phoneNumWasToggled, updateQrCode: updateCode, errorPresent: $errorinPhoneNum)
                } header: {
                    Text("Phone Number")
                } footer: {
                    Text(phoneNumWasToggled == true ? "Prospects can now see your phone number when they scan your QR code" : "Prospects will not see your phone number  when they scan your QR code")
                    
                }
                
                .headerProminence(.increased)
                
                //Linkedin
                //will haave to make a textFeild with first text, part of url, then more
                
                Section {
                    TextFeildWithToggle(placeholder: "LinkedIn Username", text: $meViewModel.linkedinUsername, toggleActive: $linkedInUsernameWasToggled, updateQrCode: updateCode, errorPresent: $errorInLinkedin)
                    
                } header: {
                    Text("Linkedin")
                } footer: {
    
                    LinkedInFooter
                    
                }
                .headerProminence(.increased)
                
                Section {
                    TextFeildWithToggle(placeholder: "Discord Username", text: $meViewModel.discordUsername, toggleActive: $discordUsernameWasToggled, updateQrCode: updateCode, errorPresent: $errorinPhoneNum)
                } header: {
                    Text("Discord")
                }      footer: {
                    DiscordFooter
                }
                .headerProminence(.increased)
                
                
//                .willAppear {
//                    
//                }
                //sheet for the QR oe
                
//
                
                //when name state variable changes,save the name to local storage and update the QRCode
                .onChange(of: meViewModel.name, perform: { newName in
                    // contactPoints[0].wrappedValue = newName
                    if(newName.isEmpty) {
                        errorInName = true
                    } else {
                        errorInName = false
                    }
                    
                    meViewModel.nameCopy = newName
                    updateCode()
                    
                    //when the name is loaded, it needs 
     
                })
                //when emailAddress state variable changes,save the name to local storage and update the QRCode
                .onChange(of: meViewModel.emailAddress, perform: { newEmail in
              //  UserDefaults.standard.set(newEmail, forKey: "users_email")
                    meViewModel.emailAddressCopy = newEmail
                        //    print(emailAddressCopy)
                    updateCode()
                    
                    
                })
                
                //when phone Number state variable changes,save the name to local storage and update the QRCode
                .onChange(of: meViewModel.phoneNumber, perform: { newPhone in
                   // UserDefaults.standard.set(newPhone, forKey: "m_users_phone")
                        meViewModel.phoneNumberCopy = newPhone
                    updateCode()
                    
                })
                .onChange(of: meViewModel.linkedinUsername, perform: { updateduserName in
              //      UserDefaults.standard.set(updateduserName, forKey: "Linkedin_Username")
                    //      contactPoints[4] = updatedDiscordUserName
                        meViewModel.linkedinUsernameCopy = updateduserName
                    updateCode()
                })
                //when the user changes the discordUsername the username is saved in userdefaults and the saved in the copy variable used for the Qr code.
                .onChange(of: meViewModel.discordUsername, perform: { updatedDiscordUserName in
                    meViewModel.discordUsernameCopy = updatedDiscordUserName
                    //  contactPoints[4] = updatedDiscordUserName
                    updateCode()
                })
                
                .onChange(of: emailWasToggled, perform: { toggleState in
                    UserDefaults.standard.set(toggleState, forKey: "emailToggleStatus")
                    
                    //if the user toggles the sharing off for the email, then set the copy variable used in the QR code to off
                    if(!toggleState){
                        meViewModel.emailAddressCopy = ""
                        updateCode()
                      //  meViewModel.saveUserInfo()
                    } else {
                        meViewModel.emailAddressCopy = meViewModel.emailAddress
                        updateCode()
                      //  meViewModel.saveUserInfo()

                    }
                })
                .onChange(of: phoneNumWasToggled, perform: { toggleState in
                    UserDefaults.standard.set(toggleState, forKey: "phoneNumberToggleStatus")
                    
                    if(!toggleState){
                        meViewModel.phoneNumberCopy = ""
                        updateCode()
                    //    meViewModel.saveUserInfo()
                    } else {
                        meViewModel.phoneNumberCopy = meViewModel.phoneNumber
                        updateCode()
                     //   meViewModel.saveUserInfo()
                    }
                   
                    
                })
                .onChange(of: linkedInUsernameWasToggled, perform: { toggleState in
                    UserDefaults.standard.set(toggleState, forKey: "linkedinToggleStatus")
                    
                    if(!toggleState){
                        meViewModel.linkedinUsernameCopy = ""
                        updateCode()
                    //    meViewModel.saveUserInfo()
                    } else {
                        meViewModel.linkedinUsernameCopy = meViewModel.linkedinUsername
                        updateCode()
                    //    meViewModel.saveUserInfo()
                    }
        
                    
                    
                })
                .onChange(of: discordUsernameWasToggled, perform: { toggleState in
                    UserDefaults.standard.set(toggleState, forKey: "discordToggleStatus")
                    
                    if(!toggleState) {
                        meViewModel.discordUsernameCopy = ""
                        updateCode()
                   
                    } else {
                        meViewModel.discordUsernameCopy = meViewModel.discordUsername
                        updateCode()
                    
                    }
                    
                
                    
                })
                
            }.onAppear {
                
                
                if !contactPointsInitialized {
                    
                    contactPoints = [$meViewModel.nameCopy,$meViewModel.emailAddressCopy,$meViewModel.phoneNumberCopy, $meViewModel.linkedinUsernameCopy, $meViewModel.discordUsernameCopy]//add the userNames and URLs here!!! tocontinue!!
                    //continue here Q!
                    print(contactPoints.count)
                }
                contactPointsInitialized = true
                updateCode() //this generates the qr code after
                
                
            }

            
            .sheet(item: $activeSheet) { item in
                switch item {
                case .qrCode:
                    QRCodeView(qrCodeImage: qrCode,isSharingEmail: $emailWasToggled,isSharingPhoneNum: $phoneNumWasToggled, isSharingDiscord: $discordUsernameWasToggled, isSharingLinkedin: $linkedInUsernameWasToggled)
                        .presentationDetents([.fraction(0.7)])
                        .environmentObject(meViewModel) //pass down this object here, so that value changes can be seen!
                case .changeEvent:
                    UserAndProspectLocationView(addReasonMessage:"userLocationUpdate")
                        .presentationDetents([.fraction(0.5 )])
                case .linkedinInstructions:
                    SafariView(url: URL(string: "https://www.linkedin.com/help/linkedin/answer/a522735")!)
                case .discordInstructions:
                    SafariView(url: URL(string: "https://www.remote.tools/remote-work/discord-tag")!)
                }
                
            }

            .defersSystemGestures(on: .all)
            
            .toolbar {
                
                toolbarButton("My QR Code", systemImage: "") {
                    activeSheet = .qrCode
                }
            }
            
            .navigationTitle("My Info")
        }
        
    }
    
    /// updates the  generated QR code image based on the users name, email, and phoneNumber.
    ///
    /// THe qrCode image is generated by calling the `generateCode` method. The view constanly calls this function as the name , email, and address parametrs change
    func updateCode()
    {
        //If there is an error in the contact Detailss then set the QRcode to nil
        guard errorInEmail == false && errorinPhoneNum == false && errorInName == false
        else {
            qrCode = nil
            return
        }
        
        var QRString = ""
        for index in 0..<contactPoints.count {
            QRString.append(contactPoints[index].wrappedValue + "\n")
        }
        print("Printing the code now!")
        print(QRString)
        
        qrCode = meViewModel.generateQRCode(from: QRString, with: qrCode)
        
    }
    
    /// Saves user info when the user clicks out of this screen
    /// makes surec ontact points values are equal to what the user sets.
 
    var LinkedInFooter: some View {
        
        VStack {
            Text(linkedInUsernameWasToggled == true ? "Prospects will be able to see your linkedin profile when they scan your QR Code": "Prospects will not see your linkedin username when they scan your QR code.")
                .padding([.bottom],10)
            
            HStack(spacing: 0) {
                Text("To lean how to find your linkedin profile URL ")
                Button(action: {
                    activeSheet = .linkedinInstructions
                }) {
                    Text("Click here")
                        .underline()
                        .font(.system(size: 9))
                    //change the font size here!!
                    //font change here!!
                    
                }
                //
            }
            
        }
        .multilineTextAlignment(.leading)
        
        
    }
    
    var DiscordFooter: some View {
        
        VStack {
            Text(discordUsernameWasToggled == true ? "Prospects will be able to see  your Discord tag when they scan your QR Code":"Prospects will not be able to see your Discord profile when they scan your QR Code")
                .padding([.bottom], 10)
            
            HStack(spacing: 0) {
                Text("To learn how to find your discord tag,")
                Button(action: {
                    activeSheet = .discordInstructions
                }) {
                    Text("Click here")
                        .underline()
                        .font(.system(size: 9))
                    //change the font size here!!
                    //font change here!!
                    
                }
            }
        }
        
        
    }
    
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
            .environmentObject(EventLocation())
    }
}


