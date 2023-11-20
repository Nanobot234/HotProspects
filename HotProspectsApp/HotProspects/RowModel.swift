//
//  RowModel.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/27/23.
//

import Foundation

//row mdodel here, now not used!!

class RowModel: ObservableObject {
    @Published var isExpandedShowingNotifcationSchedule = false
   //variable to show an alert on the parent view
    @Published var currentLocation = ""
    
    init() {}
}


