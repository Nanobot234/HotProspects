//
//  ProspectViewModel.swift
//  HotProspects
//
//  Created by Nana Bonsu on 2/21/24.
//

import Foundation


@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect] //here with the private(set) keyword, you make sure external classes can only read, but not set data

    
    let saveKey = "SavedData" //use te
    
    init() {
        //load data from userDefaults
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        
        people = []
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func add(_ prospect: Prospect){
        //add the current date you added the prospect on
        
        people.append(prospect)
        
        save()
    }
    
    func remove(_ target: Prospect) {
        people = people.filter { $0.id != target.id} //gets rif of the target you dont want
        save()
        }
    
    func removeProspectWithID(id: UUID) {
        
        if let prospect = people.first(where: {$0.id == id}) {
            remove(prospect)
        }
        save()
    }
    

    /// before the boolean value is changed, .....(finish here) but will perfrom objectWillChange.send which will tell the view heirarchy somethign s being changed and refresh everything
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save() //save here since this
    }
    
    func reminderToggle(_ prospect:Prospect) {
        objectWillChange.send()
        people.first(where: {$0.id == prospect.id})!.isReminderSet.toggle()
        save()
    }
    
    /// Saves the reminder date string for a particular prospect.
    /// - Parameter prospect: the prospect to set the reminder date string for
    func saveReminderForProspect(_ prospect: Prospect) {
        objectWillChange.send()
        people.first(where: {$0.id == prospect.id})!.lastReminderDate = prospect.lastReminderDate
        save()
    }
    
    
    /// Sets the location that the user meets a particular prospect
    /// - Parameter prospect: the prospect whose location needs to be updated
    ///
    /// The function finds the propsect in the people's array whose id matches the prospect passed in the function. Then it sets the `locationMet` variable to that prospects `LocationMet`. Before that it notifiies all views that watch this object that the array is about to change.
    func addLocationMet(_ prospect:Prospect) {
        objectWillChange.send()
        people.first(where: {$0.id == prospect.id})!.locationMet = prospect.locationMet //this updates the location of the prospect
        save()
    }
    
    //func add notes here
    func addNotesForProspect(_ prospect: Prospect) {
        objectWillChange.send()
        people.first(where: {$0.id ==  prospect.id})!.prospectNotes = prospect.prospectNotes
        save()
    }
    
   

    
    //maybe in here,actually update the prospect heres info
    func updateProspectDetails(_ prospect:Prospect) {
        objectWillChange.send()
        
        if let index = people.firstIndex(where:  {$0.id == prospect.id}) {
            //update contact information
            people[index].emailAddress = prospect.emailAddress //might now work
            people[index].name = prospect.name
            people[index].emailAddress = prospect.emailAddress
            people[index].phoneNumber = prospect.phoneNumber
        }
        save()
      
    }

}
