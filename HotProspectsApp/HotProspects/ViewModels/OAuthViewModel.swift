//
//  OAuthViewModel.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/28/24.
//

import Foundation
//import OAuthSwift

/// Describes oauth features and methods
class OAuthViewModel: ObservableObject {
   // @Published var oauthswift: OAuth2Swift
    
    @Published var authToken:String
    
    init() {
        
        authToken = ""
    }
//    init() {
//    //  oauthswift =  OAuth2Swift(consumerKey: "78cymgerbhr6qo",
//                   consumerSecret: "s9XVhLI0VqJbHogb",
//                  authorizeUrl: "https://www.linkedin.com/uas/oauth2/authorization",
//                accessTokenUrl: "https://www.linkedin.com/uas/oauth2/accessToken",
//                responseType: "code")
        
    
    
    
    
    
}
