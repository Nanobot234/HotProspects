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
    
    //MARK:  Computed Properties
    /// The prospects array stored in the environment, filtered through various conditions
    ///
    /// The value of this property is computed based  on the current `filterType` that this `ProspectView` is initialized with. Thus, only the prospects that match the condition is shown in the view
    var filteredProspects: [Prospect] {
        switch selectedFilter {
        case .all:
            return prospects.people
        case .uncontacted:
            return prospects.people.filter {!$0.isContacted}
        }
    }
    
    
    /// The  array of  filtered `Prospects` sorted by a `SortType` condition
    ///
    /// The value of this proerty is computed by sorting the elements of `filteredProspects` either by their name or recent. This sort condition is determined by the user through a context menu button.
    var filteredSortedProspects: [Prospect] {
        switch sort {
        case .name:
            return filteredProspects.sorted {$0.name < $1.name}
        case .recent:
            return filteredProspects.sorted {$0.currentDate > $1.currentDate}
            
        }
    }
    
    var searchedfilteredProspects: [Prospect] {
        
        //returns the searched for item
        searchFieldText.isEmpty ? filteredSortedProspects : filteredSortedProspects.filter {$0.name.localizedCaseInsensitiveContains(searchFieldText) || $0.emailAddress.localizedCaseInsensitiveContains(searchFieldText) || $0.currentDate.formatted().localizedCaseInsensitiveContains(searchFieldText) ||
            $0.locationMet.localizedCaseInsensitiveContains(searchFieldText)
        }
        
    }
    
    //MARK: Action Functions
    /// extracts prospect info from a QR code scan
    /// - Parameter result: value that represents whether a QR code scan was successful( `ScanResult`) or failed (`ScanError`)
    func handleScan(result: Result<ScanResult, ScanError>) {
        
        switch result {
        case .success(let result):
            isShowingScanner = false
            //have a dictionary here, to indicate which
            let details = Utilties.adjustDetailsArray(details: result.string.components(separatedBy: "\n"))
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                createNewProspect(details: details)
            }
            
            // guard details.count >= 3 else { return}
            
            //failed case
        case .failure(let error):
            //now  what to do when error!
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    /// create a new prospect and add it to the `Prospect` array.
    /// - Parameter details: An array containing the contact information of the prospect that the user just tried to add
    ///
    /// The details array will contain only the contact info that the user decides to share. Conact points that the user doesnt share will just be saved as an empty string.
    ///For example. if the user decides not to share his phone number with a prospect, than the details array will have no value for the index holding the phone number.
    func createNewProspect(details: [String]) {
        
        
        //here validate the positions
        //need to pad this array, with the correct amount empty, once you get it so that it can not misplace the detaisl
        
        newProspect.name = details[0]
        
        newProspect.emailAddress = details[1]
        newProspect.phoneNumber = details[2]

        guard details.count >= 4 else {
            if(eventLocation.currentEventOfUser == "") {
                showAddLocationView = true
            } else {
                addNewProspectToProspects()
            }
            return}
        
        if(!details[3].isEmpty) {
            newProspect.linkedinProfileURL = "https://www.linkedin.com/in/" + details[3]
        }
        
        guard details.count >= 5 else {return}
        newProspect.discordUsername = details[4]
        
        print("Profile-URL " + newProspect.linkedinProfileURL)
        newProspect.discordUsername = details[4]
        
      
     
    }
    
    func addNewProspectToProspects() {
        //here will add the notes to the prospect if there is
        
        newProspect.prospectNotes = eventLocation.newProspectNotes //set the notes of the new prospect to the environemnt value
        eventLocation.newProspectNotes = "" //sets it to empty string for next prospect to be added
        
        prospects.add(newProspect)
        
        prospects.addLocationMet(newProspect)
        
        
        newProspect = Prospect()
    }
    
    
    ///  Updates the contact information of a selected prospect in the Prospects array
    ///
    ///  This function is called on the `OnDismiss` closure after a user edits the details of a prospect.
    func updateProspect() {
        // print("LocationtoInput " + currentSelectedProspect.locationMet)
        prospects.updateProspectDetails(currentSelectedProspect)
        
    }
    
    
    ///  Removes all items in the `selectedItems` set.
    ///
    ///  The `selectedItems` set only contains prospects that the user decides  to delete by selecting it while in edit mode.
    func deleteItems() {
        //here will delete all the items with the id in the
        for prospectID in selectedItems {
            prospects.removeProspectWithID(id: prospectID)
        }
        
    }
}


/// Saves a prospect's information to the users contact book
/// - Parameters:
///   - email: the prospect's email to save
///   - phoneNumber: the prospect's phone number to save
///   - name: prospect's name to save
///   - locationMet: the location where you met the Prospect at.
func saveProspectToContacts(email: String,phoneNumber: String,name: String, locationMet: String, completion: @escaping (Bool) -> Void) {
    
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
        completion(true)
        
        
        
    } catch {
        print("Error: \(error.localizedDescription)")
        completion(false)
    }
}


