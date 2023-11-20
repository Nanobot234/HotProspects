//
//  ProspectView_Functions.swift
//  HotProspects
//
//  Created by Nana Bonsu on 11/14/23.
//

import Foundation
import Contacts
import CodeScanner
import AlertToast




extension ProspectsView {
    /// extracts prospect info from a QR code scan
    /// - Parameter result: value that represents whether a QR code scan was successful( `ScanResult`) or failed (`ScanError`)
    func handleScan(result: Result<ScanResult, ScanError>) {
        
        switch result {
          
        case .success(let result):
            isShowingScanner = false
            let details = result.string.components(separatedBy: "\n")
            guard details.count >= 3 else { return}
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                createNewProspect(details: details)
            }
            
            //failed case
        case .failure(let error):
            //now  what to do when error!
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    /// create a new prospect and add it to the `Prospect` array.
    /// - Parameter details: An array containing the name, phoneNumber and email address of the prospect
    func createNewProspect(details: [String]) {
        
        let person = Prospect()
        person.name = details[0]
        person.emailAddress = details[1]
        person.phoneNumber = details[2]
        
        if(details.count == 4){
            person.locationMet = details[3]
        }
        prospects.add(person)
        prospects.save()
        
        newProspect = person //sets the prospect here
        
        if(eventLocation.currentEvent == "") {
            showAddLocationView = true
        }
        
    }
    
    /// Updates the event or location the user meets a prospect at
    ///
    /// The function only updates the location of the most recently added prospect. This function is run when a user adds the location of a prospect immediately after scanning their QR code.
    func updateProspectLocation() {
        
        newProspect.locationMet = eventLocation.currentEventMetProspect
        print("THis is prospect location changed" + newProspect.locationMet)
        prospects.addLocationMet(newProspect) //this updates the location of the most recently added prospect.
        
        eventLocation.currentEvent = ""
    }
    

}



/// Saves a prospect's information to the users contact book
/// - Parameters:
///   - email: the prospect's email to save
///   - phoneNumber: the prospect's phone number to save
///   - name: prospect's name to save
///   - locationMet: the location where you met the Prospect at.
func saveProspectToContacts(email: String,phoneNumber: String,name: String, locationMet: String) {
    
    let contact = CNMutableContact()
    
    contact.givenName = name
    contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: email as NSString)]
    contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phoneNumber) )]
    
    contact.note = locationMet

    let store = CNContactStore()
    let saveRequest = CNSaveRequest()
    
    saveRequest.add(contact, toContainerWithIdentifier: nil)
    
    do {
        try store.execute(saveRequest)
        
       
       
        
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
