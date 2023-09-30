//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/11/23.
//

import CodeScanner
import SwiftUI
import UserNotifications

/// View to display contacts. The first 3 tabs of the app use this view to dsiplay different contacts based on filter type
struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    //have an enum for the sorting type
    enum SortType {
        case name, recent //different ways to sort the list
    }
    
    //will have the encironment object here
    
    @EnvironmentObject var viewModel:RowModel

    @EnvironmentObject var prospects: Prospects //finds prospects class, attach it to
    @State private var isShowingScanner = false //boolean to show scan info
    @State private var isShowingSortOptions = false
    //@State private var isPopoverVisible = false //shows a popover
    @State private var selectedReminderDate = Date() //this will be the date selected by the user for the reminder
    @State private var showAlert = false
    @State private var currentEventLocation = ""
    @State private var selectedProspect = Prospect()
    @State var sort: SortType = .name
    
    let filter: FilterType //no at state, since this doesnt need to change?, or wont change for  given view
    var body: some View {
        
//        GeometryReader { geometry in
            NavigationView {
                VStack {
                    List {
                        ForEach(filteredProspecs) {prospect in
                            //make the view
                            
                            
                            ItemRow(prospect: prospect, filter: filter)
                            
                            //try here
                            
                            //swipe action to add a notification
                            
                        }
                        
         
                    }
                    .navigationTitle(title)
                    
                    .toolbar {
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                isShowingScanner = true
                            } label: {
                                Label("Scan", systemImage: "qrcode.viewfinder")
                                    .labelStyle(.titleAndIcon)
                                
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Sort") {
                                //isShowingSortOptions = true
                                
                            }
                            .contextMenu {
                                Button((self.sort == .name ? "✓ " : "") + "Name") {
                                    self.sort = .name //will refresh the UI based on this
                                }
                                Button((self.sort == .recent ? "✓ " : "") + "Recent") {
                                    self.sort = .recent //will refresh the UI based on this
                                }
                                
                                //check to see if i dont have to long press it!
                                
                            }
                        }
                        
                        
                    }
                    .sheet(isPresented: $isShowingScanner) {
                        CodeScannerView(codeTypes:[.qr] , simulatedData: "Nana Bonsu\nNbonsu2000@gmail.com\n6467012471" ,completion: handleScan)
                        
                        
                        //simulated data to be enteredon screen press
                    }
                   
                    .alert("Where are you at?", isPresented:  $showAlert) {
                              TextField("Username", text: $currentEventLocation)
                                  .textInputAutocapitalization(.never)
                             
                        Button("OK") { viewModel.currentLocation = currentEventLocation}
                              Button("Cancel", role: .cancel) { }
                          } message: {
                              Text("Please enter your location or event you attended.")
                          }
                    
                    
                    Spacer()
                    
                    Button("Add my Current Event") { showAlert = true } //shows alert to the user
                    
                }
        }
            
    
    }
    
    
    ///Strign that wil l be used as the navigationView title
    var title: String {
        switch filter {
        case .none:
            return "All Prospects"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    ///n
    var filteredProspecs: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter{ $0.isContacted}
        case .uncontacted:
            return prospects.people.filter {!$0.isContacted}
        }
    }
    
    //here we sort the filtered prospect
    var filteredSortedProspects: [Prospect] {
        switch sort {
        case .name:
            return filteredProspecs.sorted {$0.name < $1.name}
        case .recent:
            return filteredProspecs.sorted {$0.currentDate < $1.currentDate}
        
        }
    
    
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        //now hide the scanner here
        
        //now make a switch statement for the results
        switch result {
        
        case .success(let result):
            
            let details = result.string.components(separatedBy: "\n")
            
            guard details.count >= 3 else { return} //this checks i  you have at lest all the contact info, could have the location as well
            
            //here will toggle the alert to show
            
            createNewProspect(details: details)
           
        
        case .failure(let error):
            //now  what to do when error!
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    

    
    func createNewProspect(details: [String]) {
        
       

        let person = Prospect()
        person.name = details[0]
        person.emailAddress = details[1]
        person.phoneNumber = details[2] //gets the phone numbe  of the person!
        
        if(details.count == 4){
            person.locationMet = details[3]
        }
        prospects.add(person) //you dont dirrect access the array, so that no one else can change its contennts. So this is using a setter for the array!
        
        prospects.save()
        
        isShowingScanner = false
        
     //   showAlert = true
    }
    
    
    //here
}


struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}


//Ok, so
