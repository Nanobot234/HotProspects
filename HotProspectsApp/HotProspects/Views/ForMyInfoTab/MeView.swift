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
    
    @State private var name = ""
    @State private var emailAddress = ""
    @State private var phoneNumber = ""
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
    
    @State private var linkedInUserName = ""
    @State private var discordUserName = ""
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    ///Generate the QR image
    let filter = CIFilter.qrCodeGenerator()
    let context = CIContext()
    

    //have a button that basically is activated when something is toggled, then will run the code conditionll
    var body: some View {
        NavigationView {
            Form {
                
                CurrentLocationView() // textFeild and button to change the current event of the user.
                
                Section {
                    VStack {
                        TextField("Name", text: $name)
                            .textContentType(.name)
                            .font(.title3)
                        
                        if(name.isEmpty){
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
                    TextFeildWithToggle(placeholder: "Email Address", text: $emailAddress, contactPoints: $contactPoints, feildWasToggled: $emailWasToggled, updateQrCode: updateCode, errorPresent: $errorInEmail)
                } header: {
                    Text("Email Address")
                } footer: {
                    Text(emailWasToggled == true ? "Prospects  can now see your email address when they scan your QR code" : "Prospects will not see your email address when they scan your QR code")
                    
                }
                .headerProminence(.increased)
                
                Section {
                    TextFeildWithToggle(placeholder: "Phone Number", text: $phoneNumber, contactPoints: $contactPoints, feildWasToggled: $phoneNumWasToggled, updateQrCode: updateCode, errorPresent: $errorinPhoneNum)
                } header: {
                    Text("Phone Number")
                } footer: {
                    Text(phoneNumWasToggled == true ? "Prospects can now see your phone number when they scan your QR code" : "Prospects will not see your phone number  when they scan your QR code")
                    
                }
                
                .headerProminence(.increased)
                
                //Linkedin
                //will haave to make a textFeild with first text, part of url, then more
                
                Section {
                    TextFeildWithToggle(placeholder: "LinkedIn Username", text: $linkedInUserName, contactPoints: $contactPoints, feildWasToggled: $linkedInUsernameWasToggled, updateQrCode: updateCode, errorPresent: $errorInLinkedin)
                    
                } header: {
                    Text("Linkedin")
                } footer: {
                    
                    
                    LinkedInFooter
                    
                }
                .headerProminence(.increased)
                
                Section {
                    TextFeildWithToggle(placeholder: "Discord Username", text: $discordUserName, contactPoints: $contactPoints, feildWasToggled: $discordUsernameWasToggled, updateQrCode: updateCode, errorPresent: $errorinPhoneNum)
                } header: {
                    Text("Discord")
                }      footer: {
                    DiscordFooter
                }
                .headerProminence(.increased)
                
                
                .onAppear {
                    updateCode()
                    
                    if !contactPointsInitialized {
                        contactPoints = [$name,$emailAddress,$phoneNumber,$linkedInUserName, $discordUserName]//add the userNames and URLs here!!! tocontinue!!
                        
                        print(contactPoints.count)
                    }
                    contactPointsInitialized = true
                    
                    name = UserDefaults.standard.string(forKey: "users_name") ?? ""
                    emailAddress = UserDefaults.standard.string(forKey: "users_email") ?? ""
                    phoneNumber = UserDefaults.standard.string(forKey:"users_phone") ?? ""
                    linkedInUserName = UserDefaults.standard.string(forKey: "linkedin_username") ?? ""
                    discordUserName = UserDefaults.standard.string(forKey: "discord_username") ?? ""
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
                .sheet(isPresented: $showingLinkedinInstructions) {
                    SafariView(url: URL(string: "https://www.linkedin.com/help/linkedin/answer/a522735")!)
                }
                .sheet(isPresented: $showingDiscordInstructions) {
                    SafariView(url: URL(string: "https://www.remote.tools/remote-work/discord-tag")!)
                }
                
                //when name state variable changes,save the name to local storage and update the QRCode
                .onChange(of: name, perform: { newName in
                    // contactPoints[0].wrappedValue = newName
                    UserDefaults.standard.set(newName, forKey: "users_name")
                    updateCode()
                    if(newName.isEmpty) {
                        errorInName = true
                    } else {
                        errorInName = false
                    }
                    
                    
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
                .onChange(of: linkedInUserName, perform: { updateduserName in updateCode()
                    UserDefaults.standard.set(updateduserName, forKey: "linkedin_UserName")
                })
                .onChange(of: discordUserName, perform: { updatedDiscordUserName in updateCode()
                    UserDefaults.standard.set(updatedDiscordUserName, forKey: "discord_username")
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
            .toolbar {
                
                toolbarButton("My QR Code", systemImage: "") {
                    showingQRCodeSheet = true
                }
            }
            
            .onAppear {
                
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
                
                qrCode = generateQRCode(from: QRString)
            }
            
            /// Saves user info when the user clicks out of this screen
            func saveUserInfo() {
                UserDefaults.standard.set(name, forKey: "users_name")
                UserDefaults.standard.set(emailAddress, forKey: "users_email")
                UserDefaults.standard.set(phoneNumber, forKey: "users_phone")
                UserDefaults.standard.set(linkedInUserName, forKey: "linkedin_UserName")
                UserDefaults.standard.set(linkedInUserName, forKey: "discord_username")
            }
            
            var LinkedInFooter: some View {
                
                VStack {
                    Text(linkedInUsernameWasToggled == true ? "Prospects will be able to see your linkedin profile when they scan your QR Code": "Prospects will not see your linkedin username when they scan your QR code.")
                        .padding([.bottom],10)
                    
                    HStack(spacing: 0) {
                        Text("To lean how to find your linkedin profile URL ")
                        Button(action: {
                                showingLinkedinInstructions = true
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
                                showingLinkedinInstructions = true
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


