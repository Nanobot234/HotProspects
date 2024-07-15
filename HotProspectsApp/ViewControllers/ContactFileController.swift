//
//  ContactFileController.swift
//  HotProspects
//
//  Created by Nana Bonsu on 7/8/24.
//

import Contacts
import SwiftUI
import ContactsUI

struct AddContactView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var name:String
    var phoneNumber:String
    var emailAddress: String
    var discordUsername: String
    var linkedinProfileURL: String
    var locationMet: String
    var userNameString: String { 
         let string = Utilties.returnUserNameFromURL(urlString: linkedinProfileURL)!
        return string
    }
   
    
    
    /// prepares the view controller with relevant  contact details
    /// - Parameter context: <#context description#>
    /// - Returns: <#description#>
    func makeUIViewController(context: Context) -> UINavigationController {
        
        let contact = CNMutableContact()
        
        contact.givenName = name
        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: emailAddress as NSString)]
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phoneNumber) )]
        //fix this here!!
        contact.note = locationMet
        
        var socialProfiles = [CNLabeledValue<CNSocialProfile>]()
        
   
        if !linkedinProfileURL.isEmpty {
            let linkedinUsernameURL =  CNSocialProfile(urlString: linkedinProfileURL, username: userNameString,  userIdentifier: nil, service: CNSocialProfileServiceLinkedIn)
            
            socialProfiles.append(CNLabeledValue(label: "LinkedIn", value: linkedinUsernameURL))
        }
        
        if !discordUsername.isEmpty {
            let discordProfile = CNSocialProfile(urlString: nil, username: discordUsername, userIdentifier: nil, service: "Discord")
                           socialProfiles.append(CNLabeledValue(label: "Discord", value: discordProfile))
        }
        
        contact.socialProfiles = socialProfiles
        //detaild here!
        let contactViewController = CNContactViewController(forNewContact: contact)
        contactViewController.delegate = context.coordinator
        let navigationController = UINavigationController(rootViewController: contactViewController)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    //TODO: make function here to store the values!
   
    class Coordinator: NSObject, UINavigationControllerDelegate, CNContactViewControllerDelegate {
        var parent: AddContactView
        
        init(_ parent: AddContactView) {
            self.parent = parent
        }
        
        func saveContact(contact: CNMutableContact) {

            let store = CNContactStore()
            let saveRequest = CNSaveRequest()
      
            saveRequest.add(contact, toContainerWithIdentifier: nil)
            
            do {
                try store.execute(saveRequest)
            } catch {
                print("Error: \(error.localizedDescription)")
                
            }
        }
        
        
        func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
            
           
            //basic error handling, dismiss if problem with the contact
            guard let contact = contact else {
                          parent.presentationMode.wrappedValue.dismiss()
                          return
                      }
            
            let mutableContact = contact.mutableCopy() as! CNMutableContact
            
//            var socialProfiles = [CNLabeledValue<CNSocialProfile>]()
//            
//            if !parent.linkedinUsername.isEmpty {
//                let linkedinUsernameURL =  CNSocialProfile(urlString: nil, username: parent.linkedinUsername, userIdentifier: nil, service: CNSocialProfileServiceLinkedIn)
//                
//                socialProfiles.append(CNLabeledValue(label: "LinkedIn", value: linkedinUsernameURL))
//            }
//            
//            if !parent.discordUsername.isEmpty {
//                let discordProfile = CNSocialProfile(urlString: nil, username: parent.discordUsername, userIdentifier: nil, service: "Discord")
//                               socialProfiles.append(CNLabeledValue(label: "Discord", value: discordProfile))
//            }
            //
            
           // mutableContact.socialProfiles = socialProfiles
            
            saveContact(contact: mutableContact) //saves thec ontact in contact storage!
            
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
