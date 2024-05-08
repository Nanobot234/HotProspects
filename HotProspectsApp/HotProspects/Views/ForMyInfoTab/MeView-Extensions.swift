//
//  MeView-Extensions.swift
//  HotProspects
//
//  Created by Nana Bonsu on 4/17/24.
//

import Foundation
import UIKit

extension MeView {
    
    
    /// gets the URL for a provider that will be opened in Safari view
    /// - Returns: <#description#>
    func getURL() async -> URL {
 
//            do {
//                let url = try await client.auth.getOAuthSignInURL(provider: .linkedin)
//                print("Thsi is the url + \(url.absoluteString)")
//                return url
//            } catch {
//                // Handle error
//                print("Error with oauth?: \(error.localizedDescription)")
//                // Return a default URL or throw the error
//                
//            }
//        
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
   
    
    /// Retrieve the users username from Discord
    ///
    /// In the function, the `OAuthProviderManager` class makes a GET request to the Discord Users API and returns a userprofile object. The username is then parsed from this object
    /// - Parameter accessToken: The acessToken that will be used for this request;
//    func getDiscordUserName(accessToken: String) {
//        OAuthProviderManager.shared.getDiscordUserProfile(accessToken: accessToken) { result in
//            switch result {
//            case .success(let userProfile):
//                if let username = userProfile["username"] as? String {
//                            print("Username: \(username)")
//                        } else {
//                            print("Username not found in user profile")
//                        }
//                    case .failure(let error):
//                        print("Failed to get user profile: \(error.localizedDescription)")
//                    }
//                NEEDS TO INCLUDE FROm OTHER FUNCTION
//            }
//    }
    
    /// Retrieves the access token from the Discord API by exchanhign the auth code
    /// - Parameter authCode: the authorization code retrieved when a user logs into their discord account
    func getDiscordAccessTokenFromAuthCode(authCode:String) {
        
//        OAuthProviderManager.shared.exchangeAuthCodeForToken(authorizationCode: authCode, redirectURI: redirectURI, clientID: APIKeys.DiscordClientID, clientSecret: APIKeys.DiscordClientSecret, provider: "discord") { result in
//            switch result {
//            case .success(let accessToken):
//                
//                print("Access token is \(accessToken)")
//                //do something with access token, make request
//                getDiscordUserName(accessToken: accessToken) //get Discord name here!
//                
//                
//            case .failure(let error):
//                print(error.localizedDescription) //see whats really going on!!
//            }
//        }
    }
    
    
}
// MARK: Button Code for Oauth (On Puase For Now)


//
//let LinkedInAuthURL = "https://www.linkedin.com/oauth/v2/authorization"
//let callBackURLSceme = "hotprospects"
//let redirectURI = "https://vvooyepqemtgjzktpalv.supabase.co/auth/v1/callback"
//
//
//@State var providerAuthURL =  URL(string: "")
//@State var providerURLSring = ""
//
//
//
//
//let client = SupabaseClient(supabaseURL: URL(string: "https://vvooyepqemtgjzktpalv.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ2b295ZXBxZW10Z2p6a3RwYWx2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTEzOTkyOTEsImV4cCI6MjAyNjk3NTI5MX0.8CkiZo0Zq5OLq8YWLAmGk3qSh8newTftqtBwadW8mCM")

//Button("Connect You Discord") {
//    startingWebAuthforDiscord = true
//    print("Starting webauth now \(startingWebAuthforDiscord)")
//}
//.webAuthenticationSession(isPresented: $startingWebAuthforDiscord) {
//    let urlVal = UserDefaults.standard.string(forKey: "oauthURL")!
//    
//    return WebAuthenticationSession(url: URL(string: urlVal)!, callbackURLScheme: callBackURLSceme) { result in
//        switch result {
//            
//        case .success(let result):
//            print("Got here")
//            let items = URLComponents(string: result.absoluteString)?.queryItems
//            let code = items?.first(where: {$0.name == "code"})?.value
//            
//            //see how to hie theclient ID, form Gemini thing
//            Task {
//                getDiscordAccessTokenFromAuthCode(authCode: code!)
//            }
//            
//        case .failure(let err):
//            
//            print(err.localizedDescription)
//        }
//    }
//    .prefersEphemeralWebBrowserSession(false)
//}

//
//Button("Connect You Linkedin") {
//    startingWebAuthforLinkedin = true
//    print("Starting webauth now \(startingWebAuthforLinkedin)")
//}
//.webAuthenticationSession(isPresented: $startingWebAuthforLinkedin) {
//    let urlVal = UserDefaults.standard.string(forKey: "oauthURL")!
//    return WebAuthenticationSession(url: URL(string: urlVal)!, callbackURLScheme: callBackURLSceme) { result in
//        switch result {
//            
//        case .success(let result):
//            print("Got here")
//            let items = URLComponents(string: result.absoluteString)?.queryItems
//            let code = items?.first(where: {$0.name == "code"})?.value
//            
//            
//        case .failure(let err):
//            
//            print(err.localizedDescription)
//            
//        }
//    }
//    .prefersEphemeralWebBrowserSession(false)
//}
