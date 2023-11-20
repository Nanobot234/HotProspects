//
//  Prospect.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/11/23.
//

import SwiftUI


/// <#Description#>
class Prospect: Identifiable, Codable, Equatable {
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
        if(lhs.name == rhs.name && lhs.emailAddress == rhs.emailAddress && lhs.phoneNumber == rhs.phoneNumber) {
            return true
        } else {
            return false
        }
    }
    
     static let example: Prospect = Prospect()
     
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var phoneNumber = ""
    fileprivate(set) var isContacted = false //, fileprivate(set) this means that this property can only be written from the current file, but read elsewhere. SO cant change this isContacted variable in a rough, or unintended way!
    
    ///The place or event where the person met his contact
    var locationMet = ""
    var currentDate = Date()

    
    var reminderToggle = false
     
     init() {}
     
     init(name: String, emailAddress: String, phoneNumber: String) {
         self.name = name
         self.emailAddress = emailAddress
         self.phoneNumber = phoneNumber
         
     }
     
  }

@MainActor class EventLocation: ObservableObject {
    
    @Published var currentEvent: String = ""
    
    @Published var changeEvent: Bool = false
    
    @Published var currentEventMetProspect: String = ""
    
}

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
        
    /// toggle the `isContacted` boolean of a prospect.
    ///
    /// before the boolean value is changed, .....(finish here) but will perfrom objectWillChange.send which will tell the view heirarchy somethign s being changed and refresh everything
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save() //save here since this
    }
    
    func reminderToggle(_ prospect:Prospect) {
        objectWillChange.send()
        people.first(where: {$0.id == prospect.id})!.reminderToggle.toggle()
        
    }
    
    func addLocationMet(_ prospect:Prospect) {
        objectWillChange.send()
        people.first(where: {$0.id == prospect.id})!.locationMet = prospect.locationMet //this updates the location of the prospect
        save()
    }
    
    //maybe in here,actually update the prospect heres info
    func updateProspectDetails(_ prospect:Prospect) {
        objectWillChange.send()
        if let index = people.firstIndex(where:  {$0.id == prospect.id}) {
            people[index] = prospect
        }
        save()
      
    }
    
    
    
}
