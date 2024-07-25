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
    @EnvironmentObject var prospects: Prospects
    /// Prospect that is selcted by the user to be added to contacts.
    var prospect: Prospect
    var userNameString: String {
        let string = Utilties.returnUserNameFromURL(urlString: prospect.linkedinProfileURL)!
        return string
    }
    
//    @Binding var addedToContacts: Bool
   
    
    
    /// prepares the view controller with relevant  contact details
    /// - Parameter context: <#context description#>
    /// - Returns: <#description#>
    func makeUIViewController(context: Context) -> UINavigationController {
        
        let contact = CNMutableContact()
        
        contact.givenName = prospect.name
        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: prospect.emailAddress as NSString)]
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: prospect.phoneNumber) )]
        //fix this here!!
        contact.note = prospect.locationMet
        
        var socialProfiles = [CNLabeledValue<CNSocialProfile>]()
        
   
        if !prospect.linkedinProfileURL.isEmpty {
            let linkedinUsernameURL =  CNSocialProfile(urlString: prospect.linkedinProfileURL, username: userNameString,  userIdentifier: nil, service: CNSocialProfileServiceLinkedIn)
            
            socialProfiles.append(CNLabeledValue(label: "LinkedIn", value: linkedinUsernameURL))
        }
        
        if !prospect.discordUsername.isEmpty {
            let discordProfile = CNSocialProfile(urlString: nil, username: prospect.discordUsername, userIdentifier: nil, service: "Discord")
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
            
            saveContact(contact: mutableContact) //saves thec ontact in contact storage!
            
          //parent.addedToContacts = true //changes the binding value to true when you added to contacts!
            
            parent.prospects.addedToContacts(parent.prospect)
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
