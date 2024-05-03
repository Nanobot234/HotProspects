//
//  OAuthViewModel.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/28/24.
//

import Foundation
import Alamofire
//import OAuthSwift

/// Describes functions that will be utilized for authentication. Will specify functions used to make requests to the relevant APIS
class OAuthProviderManager: ObservableObject {
    // @Published var oauthswift: OAuth2Swift
    
    static let shared = OAuthProviderManager()
    //will have static variables for the request of the both APIs being suedd!!

    let tokenURL = "https://discord.com/api/v10/oauth2/token"
    //static let accessTOken hre!!!
    

    
    func exchangeAuthCodeForToken(authorizationCode: String, redirectURI: String, clientID: String, clientSecret: String, provider: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        
        
        guard let url = URL(string: tokenURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        print(authorizationCode)
        let parameters: [String: String] = [
            "grant_type": "authorization_code",
            "code": authorizationCode,
            "client_id": clientID,
            "client_secret": clientSecret,
            "redirect_uri": redirectURI
        ]
        
        AF.request(tokenURL,method: .post, parameters: parameters)
            .responseString { response in
                if let error = response.error {
                    completion(.failure(error))
                }
                
                guard let data = response.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    completion(.failure(NSError(domain: "com.yourapp.error", code: 1, userInfo: ["message": "Failed to parse response data"])))
                    return
                }
                
                guard let accessToken = json["access_token"] as? String else {
                    completion(.failure(NSError(domain: "com.yourapp.error", code: 2, userInfo: ["message": "Missing access token in response"])))
                    return
                }
                
                completion(.success(accessToken))
                
                
                //        let parameters = [
                //            "client_id": clientID,
                //            "client_secret": clientSecret,
                //            "grant_type": "authorization_code",
                //            "code": authorizationCode,
                //            "redirect_uri": redirectURI,
                //        ]
                //        
                
                
                //        var request = URLRequest(url: url)
                //        print(url.absoluteString)
                //        
                //         //
                //        request.httpMethod = "POST"
                //        
                //        let bodyData = "grant_type=authorization_code&code=\(authorizationCode)&redirect_uri=\(redirectURI)&client_id=\(clientID)&client_secret=\(clientSecret)"
                //        
                //        request.httpBody = bodyData.data(using: .utf8)
                //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                //           
                //        let postData = parameters.map { "\($0)=\($1)" }.joined(separator: "&")
                //        request.httpBody = postData.data(using: .utf8)
                
                //        let session = URLSession.shared
                //        let task = session.dataTask(with: request) { data, response, error in
                //            guard let data = data, error == nil else {
                //                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                //                return
                //            }
                //            
                //            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                //                completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                //                return
                //            }
                //            
                //            guard let httpResponse = response as? HTTPURLResponse else {
                //                    let error = NSError(domain: "Invalid Response", code: -1, userInfo: nil)
                //                    completion(.failure(error))
                //                    return
                //                }
                ////
                ////                if (400...499).contains(httpResponse.statusCode) {
                ////                    if let data = data {
                ////                        let responseString = String(data: data, encoding: .utf8)
                ////                        print("Bad Request Error: \(responseString ?? "Unknown Error")")
                ////                    }
                ////                    completion(.failure(NSError(domain: "Bad Request", code: httpResponse.statusCode, userInfo: nil)))
                ////                    return
                ////                }
                ////            
                //            
                //            do {
                //                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                //                   
                //                   let accessToken = json["access_token"] as? String {
                //                    print(json)
                //                    completion(.success(accessToken))
                //                } else {
                //                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                //                }
                //            } catch {
                //                completion(.failure(error))
                //            }
                //        }
                //        
                //        task.resume()
            }
    }
    
    
    
    func getDiscordUserProfile(accessToken: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "https://discord.com/api/v3/users/@me") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
  
}


//func exchangeCode(code: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
//    let url = URL(string: "\(apiEndpoint)/oauth2/token")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    
//    let bodyData = "grant_type=authorization_code&code=\(code)&redirect_uri=\(redirectURI)"
//    request.httpBody = bodyData.data(using: .utf8)
//    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//    request.setValue("Basic \(base64EncodedCredentials)", forHTTPHeaderField: "Authorization")
//
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            completion(.failure(error))
//            return
//        }
//        
//        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
//            let error = NSError(domain: "HTTP Error", code: statusCode, userInfo: nil)
//            completion(.failure(error))
//            return
//        }
//        
//        guard let data = data else {
//            let error = NSError(domain: "Empty Response Data", code: -1, userInfo: nil)
//            completion(.failure(error))
//            return
//        }
//        
//        do {
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                completion(.success(json))
//            } else {
//                let error = NSError(domain: "Invalid Response Data", code: -1, userInfo: nil)
//                completion(.failure(error))
//            }
//        } catch {
//            completion(.failure(error))
//        }
//    }
//    
//    task.resume()
//}
