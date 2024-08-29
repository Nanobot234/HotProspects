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
    
    @EnvironmentObject var meViewModel: MeViewModel
   
    ///  Will be used as a copy of the name of the user. This copy will be manippluated and used to display the users information in the QR code.
    
    
    @State private var contactPoints = [Binding<String>]()
    
    @EnvironmentObject var eventLocation: EventLocation
    
    @State private var contactPointsInitialized: Bool = false //continue!
    //   @State var copyOfContacts = [String]()
    @AppStorage("firstTimeLoading") var firstTimeLoading: Bool = false
    
    
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
                    Text("Email")
                } footer: {
                    Text(emailWasToggled == true ? "Your email will be visible when others scan your code" : "Your email will not will be visible when others scan your code")
                    
                }
                .headerProminence(.increased)
                
                Section {
                    TextFeildWithToggle(placeholder: "Phone Number", text: $meViewModel.phoneNumber, toggleActive: $phoneNumWasToggled, updateQrCode: updateCode, errorPresent: $errorinPhoneNum)
                } header: {
                    Text("Phone Number")
                } footer: {
                    Text(phoneNumWasToggled == true ? "Your phone number will be visible when others scan your code" : "Your phone number will not be visible when others scan your code")
                    
                }
                
                .headerProminence(.increased)
                
                //Linkedin
                //will haave to make a textFeild with first text, part of url, then more
                
                Section {
                    TextFeildWithToggle(placeholder: " Username or Profile Url", text: $meViewModel.linkedinUsername, toggleActive: $linkedInUsernameWasToggled, updateQrCode: updateCode, errorPresent: $errorInLinkedin)
                    
                } header: {
                    Text("LinkedIn")
                } footer: {
    
                    LinkedInFooter
                    
                }
                .headerProminence(.increased)
                
                Section {
                    TextFeildWithToggle(placeholder: " Username", text: $meViewModel.discordUsername, toggleActive: $discordUsernameWasToggled, updateQrCode: updateCode, errorPresent: $errorinPhoneNum)
                } header: {
                    Text("Discord")
                }      footer: {
                    DiscordFooter
                }
                .headerProminence(.increased)
                
                
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
                
                //checks if the array of contact info points is initalized already. If not initiazlie it with the stored values and also update the qrCode
                if !contactPointsInitialized {
                    contactPoints = [$meViewModel.nameCopy,$meViewModel.emailAddressCopy,$meViewModel.phoneNumberCopy, $meViewModel.linkedinUsernameCopy, $meViewModel.discordUsernameCopy]//add the userNames and URLs here!!! tocontinue!!
                    //continue here Q!
                    updateCode() //will update the code, on the first run too
                    print(contactPoints.count)
                }
                contactPointsInitialized = true
                updateCode() //this generates the qr code after
                
                
                firstTimeLoading = true
                
            }

            
            .sheet(item: $activeSheet) { item in
                switch item {
                case .qrCode:
                    QRCodeView(qrCodeImage: meViewModel.qrCode,isSharingEmail: $emailWasToggled,isSharingPhoneNum: $phoneNumWasToggled, isSharingDiscord: $discordUsernameWasToggled, isSharingLinkedin: $linkedInUsernameWasToggled, updateQRCode: updateCode)
                        .presentationDetents([.fraction(0.7)])
                        //pass down this object here, so that value changes can be seen!
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
                
                toolbarButton("QR Code", systemImage: "") {
                    activeSheet = .qrCode
                }
            }
            
            .navigationTitle("My Info")
            .tint(Color.cyan)
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
            meViewModel.qrCode = nil
            return
        }
        
        var QRString = ""
        for index in 0..<contactPoints.count {
            QRString.append(contactPoints[index].wrappedValue + "\n")
        }
        print("Printing the code now!")
        print(QRString)
     
            meViewModel.qrCode = meViewModel.generateQRCode(from: QRString, with: meViewModel.qrCode)
        
    }
    
    //have function i that checks for errors, in the name first, then call that in update code first. THen after that gauard statement , then wills et qr coe
    /// Saves user info when the user clicks out of this screen
    /// makes surec ontact points values are equal to what the user sets.
 
    var LinkedInFooter: some View {
        
        VStack {
            Text(linkedInUsernameWasToggled == true ? "Your LinkedIn will be visible when others scan your code": "Your LinkedIn will not be visible when others scan your code")
                .padding([.bottom],10)
            
            VStack(spacing: 0) {
                Text("To learn how to find your linkedin profile url ")
                Button(action: {
                    activeSheet = .linkedinInstructions
                }) {
                    Text("Click here")
                        .underline()
                        .font(.system(size: 15))
                    //change the font size here!!
                    //font change here!!
                    
                }
                //
            }
            
        }
        //     .multilineTextAlignment()
        
        
    }
    
    var DiscordFooter: some View {
        
        VStack {
            Text(discordUsernameWasToggled == true ? "Your Discord will be visible when others scan your code":"Your Discord will not be visible when others scan your code")
                .padding([.bottom], 10)
            
            VStack(spacing: 0) {
                Text("To learn how to find your discord tag,")
                Button(action: {
                    activeSheet = .discordInstructions
                }) {
                    Text("Click here")
                        .underline()
                        .font(.system(size: 15))
                    //change the font size here!!
                    //font change here!!
                    
                }
            }
        }
        
        
    }
    
    func checkForContactInfoErrors() {
        
        
    }
    
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
            .environmentObject(EventLocation())
            .environmentObject(MeViewModel())
    }
}


