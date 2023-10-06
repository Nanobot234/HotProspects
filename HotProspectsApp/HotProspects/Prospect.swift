//
//  Prospect.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/11/23.
//

import SwiftUI


/// <#Description#>
 class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var phoneNumber = ""
    fileprivate(set) var isContacted = false //, fileprivate(set) this means that this property can only be written from the current file, but read elsewhere. SO cant change this isContacted variable in a rough, or unintended way!
    
    ///The place or event where the person met his contact
    var locationMet = ""
    var currentDate = Date()
    var reminderToggle = false
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
        people.append(prospect)
        save()
    }
    
    func remove(_ target: Prospect) {
        people = people.filter { $0.id != target.id} //gets rif of the target you dont want
        save()
        
            
        }
        
    ///The following function will toggle the boolena but will perfrom objectWillChange.send which will tell the view heirarchy somethign s being changed and refresh everything
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save() //save here since this
    }
    
    func reminderToggle(_ prospect:Prospect) {
        objectWillChange.send()
        people.first(where: {$0.id == prospect.id})!.reminderToggle.toggle()
        
    }
}
