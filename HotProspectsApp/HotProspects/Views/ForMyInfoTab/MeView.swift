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
import Supabase

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
    @State private var startingWebAuth = false
    
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    ///Generate the QR image
    let filter = CIFilter.qrCodeGenerator()
    let LinkedInAuthURL = "https://www.linkedin.com/oauth/v2/authorization"
    let callBackURLSceme = "hotprospects"
    let clientID = "78cymgerbhr6qo"
    let redirectURI = "https://vvooyepqemtgjzktpalv.supabase.co/auth/v1/callback"
    
    @State var providerAuthURL =  URL(string: "")
    @State var providerURLSring = ""
    
    var completeauthorizationURL:URL {
        let authorizationURLString = "https://www.linkedin.com/oauth/v2/authorization"
         //in developer portal!!
        let scope = "openid%20profile%20email"
        
         let authorizationURL = URL(string: "\(authorizationURLString)?response_type=code&client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=\(scope)")!
        
        return authorizationURL
    }
    
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://vvooyepqemtgjzktpalv.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ2b295ZXBxZW10Z2p6a3RwYWx2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTEzOTkyOTEsImV4cCI6MjAyNjk3NTI5MX0.8CkiZo0Zq5OLq8YWLAmGk3qSh8newTftqtBwadW8mCM")

    
    
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
        
             
                    Button("Connect You Linkedin") {
                        startingWebAuth = true
                        print("Starting webauth now \(startingWebAuth)")
                        Task {
                            
                            
                            // providerAuthURL = await getURL()
                            
                      
//                            let items = URLComponents(string: urlWithToken.absoluteString)?.queryItems
//
//                            let code = items?.first(where: {$0.name == "code"})?.value
//
                        }
                        
//                        Task {
//                            do {
//                                let urlWithToken = try await webAuthenticationSession.authenticate(using: completeauthorizationURL, callbackURLScheme: callBackURLSceme, preferredBrowserSession: )
//
//                                let items = URLComponents(string: urlWithToken.absoluteString)?.queryItems
//                                                           let code = items?.first(where: {$0.name == "code"})?.value
//
//                            }
//                        }
                        
                    }
                    .webAuthenticationSession(isPresented: $startingWebAuth) {
                        
                        let urlVal = UserDefaults.standard.string(forKey: "oauthURL")!
                        return WebAuthenticationSession(url: URL(string: urlVal)!, callbackURLScheme: callBackURLSceme) { result in
                            switch result {

                            case .success(let result):
                                print("Got here")
                                let items = URLComponents(string: result.absoluteString)?.queryItems
                                let code = items?.first(where: {$0.name == "code"})?.value
                                
                                exchangeAuthorizationCodeForAccessToken(code!)
                            case .failure(let err):

                                print(err.localizedDescription)

                            }



                        }
                        .prefersEphemeralWebBrowserSession(false)
                    }
                
                
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
        .onAppear {
            Task {
                do {
                    providerAuthURL = try await client.auth.getOAuthSignInURL(provider: .linkedin)
                    
                    providerURLSring = providerAuthURL!.absoluteString
                    
                    UserDefaults.standard.setValue(providerURLSring, forKey: "oauthURL")
                    
                    print("Provider URL \(providerURLSring)")
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
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
    
    func getURL() async -> URL {
 
            do {
                let url = try await client.auth.getOAuthSignInURL(provider: .linkedin)
                print("Thsi is the url + \(url.absoluteString)")
                return url
            } catch {
                // Handle error
                print("Error with oauth?: \(error.localizedDescription)")
                // Return a default URL or throw the error
                
            }
        
        return URL(string: "")!
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
    
    func exchangeAuthorizationCodeForAccessToken(_ code: String) {
        
        print("Gotten here")
        let tokenURLString = "https://www.linkedin.com/oauth/v2/accessToken"
       
        let clientSecret = "s9XVhLI0VqJbHogb"

        // Construct the request body
        let requestBody = "grant_type=authorization_code&code=\(code)&redirect_uri=\(redirectURI)&client_id=\(clientID)&client_secret=\(clientSecret)"

        // Make a POST request to the token endpoint
        // Handle the response to obtain the access token
        
        let url = URL(string: tokenURLString)!
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           request.httpBody = requestBody.data(using: .utf8)
           
           // Perform the request
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   print("Error: \(error?.localizedDescription ?? "Unknown error")")
                   return
               }
               
               // Parse the response data
               if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                   if let accessToken = json["access_token"] as? String {
                       // Access token obtained successfully
                       print(" My Access Token: \(accessToken)")
                       // Use the access token for further API requests
                   } else if let errorDescription = json["error_description"] as? String {
                       // Error response from LinkedIn
                       print("Error: \(errorDescription)")
                   } else {
                       // Unexpected response format
                       print("Unexpected response format")
                   }
               } else {
                   print("Failed to parse response")
               }
           }
           
           task.resume()
    }
    
    
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
            .environmentObject(EventLocation())
    }
}

