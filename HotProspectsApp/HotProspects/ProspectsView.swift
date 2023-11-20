//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/11/23.
//

import CodeScanner
import SwiftUI
import UserNotifications
import AlertToast


/// View to display contacts. The first 3 tabs of the app use this view to dsiplay different contacts based on filter type
struct ProspectsView: View {
    
    /// enum has 3 keywords for the contact status of the prospect. None shows both contacted and uncontacted
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    ///enum with keywords to describe what the prospects can be sorted by.  The enum
    enum SortType {
        case name, recent //different ways to sort the list
    }
    
    
    ///using the prospects stored in the environment
    @EnvironmentObject var prospects: Prospects
    
    @EnvironmentObject var eventLocation: EventLocation
    
    ///boolean value to determine if the QR code sheet is shown or not
    @State var isShowingScanner = false
    
    ///boolean used to show teh alert to a user allowing them to enter location details
    @State  var showAlert = false
    
    @State  var showAddLocationView = false
    
    ///sets text for the current Location
   // @State  var currentEventLocation = ""
    
    
    ///teh most recently added prospect , used to set the location met of a prospect.
    @State  var newProspect = Prospect()
    
    
    /// The prospect that the user taps on in the list of prospects. Used to provide prospect details to edit view
    @State  var currentSelectedProspect = Prospect()
    
    ///  shows the edit sheet or doesnt.
    @State  var showEditScreen = false
    
    /// Enumerator value that decides how the list of prospects is sorted. The default is set to sort the list by name
    @State var sort: SortType = .name
    
    /// activate toast message (may need to make this in observableObject
    @State var presentToast = false
    
    @State var updatedUserLcoation = ""
    
    
    /// The styling of the added to contacts alert
var addToContactsAlertStyle = AlertToast.AlertStyle.style(backgroundColor: Color.gray, titleColor: nil, subTitleColor: nil, titleFont: nil, subTitleFont: nil)
    
    ///value based on `FilterType` enumeration
    ///
    /// The filter variable is given a value when `ProspectsView` is instantiated,
    let filter: FilterType
    
    
    
    /// The navigation title for the view
    ///
    /// The navigation title is computed based on the `FilterType` for the current view
    var navigationBarTitle: String {
        switch filter {
        case .none:
            return "All Prospects"
        case .contacted:
            return "Contacted Prospects"
        case .uncontacted:
            return "Uncontacted Prospects"
        }
    }
    
    var body: some View {
        
        NavigationView {
            
            
            //show Location
            //The list displays a vertical row of `ItemRow` views.
            VStack {
                
                
                CurrentLocationView()
                
                List {
                    
                    ForEach(filteredSortedProspects) {prospect in
                        ItemRow(prospect: prospect, filter: filter, toast: $presentToast)
                        //the prospect selected by the user is stored in the currentSelectedProspect.
                        
                            .onTapGesture {
                                
                                
                                currentSelectedProspect = Prospect(name: prospect.name, emailAddress: prospect.emailAddress, phoneNumber: prospect.phoneNumber)
                                currentSelectedProspect.id = prospect.id
                                currentSelectedProspect.locationMet = prospect.locationMet
                                
                                print(prospect.locationMet)
                                print(currentSelectedProspect.id)
                                //TODO: Decide if the dispatch queue is actually needed
                                // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showEditScreen = true
                                //}
                            }
                            .contextMenu {
                                // Finish this section or.
                                
                                Button {
                                    //TODO: Add code here eventually for contacts storage
                                    
                                    saveProspectToContacts(email: prospect.emailAddress, phoneNumber: prospect.phoneNumber, name: prospect.name, locationMet: prospect.locationMet)
                                } label: {
                                    Label("Add to Contacts", systemImage: "plus")
                                }
                                
                            }
                    }
                    
                }
                //            .onChange(of: prospects) { newPros in
                //
                //
                //            }
                //
                
                .navigationBarTitle(navigationBarTitle)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        toolbarButton("Scan", systemImage: "qrcode.viewfinder") {
                            isShowingScanner = true
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        //TODO: Extract this button to the view file, to shorten the code
                        Button("Sort") {
                            
                        }
                        .contextMenu {
                            Button((self.sort == .name ? "✓ " : "") + "Name") {
                                self.sort = .name //will refresh the UI based on this
                            }
                            Button((self.sort == .recent ? "✓ " : "") + "Recent") {
                                self.sort = .recent //will refresh the UI based on this
                            }
                        }
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes:[.qr] , simulatedData: "Nana Bonsu\nNbonsu2000@gmail.com\n6467012471" ,completion: handleScan)
                    
                }
                .sheet(isPresented: $showEditScreen, onDismiss:  updateProspect) {
                    EditProspectDetailsView(prospect: $currentSelectedProspect)
                    
                }
                
                
                //
                .sheet(isPresented: $showAddLocationView, onDismiss: updateProspectLocation) {
                    AddLocationView(addReasonMessage:"prospectLocation")
                        .presentationDetents([.fraction(0.4)])
                }
                
                .sheet(isPresented: $eventLocation.changeEvent) {
                    AddLocationView(addReasonMessage:"userLocationUpdate")
                        .presentationDetents([.fraction(0.4)])
                    
                }
                
                
                
                
                .overlay(viewtoOverlay, alignment: .center)
                
                .toast(isPresenting: $presentToast) {
                    
                    AlertToast(displayMode: .banner(.slide), type: .complete(Color.green), title: "Saved to contact", style: Optional(addToContactsAlertStyle))
                    
                }
                
                
            }
            .minimumScaleFactor(0.4)
            
        }
    }
    
    /// The prospects array stored in the environment, filtered through various conditions
    ///
    /// The value of this property is computed based  on the current `filterType` that this `ProspectView` is initialized with. Thus, only the prospects that match the condition is shown in the view
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter{ $0.isContacted}
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
    
    var viewtoOverlay: some View {
        if(prospects.people.isEmpty) {
            return AnyView(Text("No Prospects Saved")
                .font(.system(size: 30))
                .fontWeight(.bold))
        } else  {
            return AnyView(EmptyView())
        }
    }
    
    func updateProspect() {
        print("LocationtoInput " + currentSelectedProspect.locationMet)
        prospects.updateProspectDetails(currentSelectedProspect)
        
    }
}
    

  
  


/// View that displays a textfeild for a user to add a location or event they met a prospect at. This view is displayed inside of a detented sheet.
struct AddLocationView: View {
    
    @EnvironmentObject var prospects: Prospects
    
    @EnvironmentObject var eventLocation: EventLocation
   // @Binding var currentEventLocation:String //maybe make this a binding to use this
    @Environment(\.dismiss) var dismiss
    ///State if you are setting an event location for all newly added Prospects or not.
    ///
    /// String indicates if a user updates the location that they are attending or sets a location met for an individual prospect,
     var addReasonMessage:String
    
    @State var userLocationString = ""
    
  //  var prospect: Prospect
    var body: some View {
        VStack(alignment: .center) {
            Text(addReasonMessage == "userLocationUpdate" ? "What Event are You Attending" : "Enter the Location or Event You Met This Prospect At")
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            //how to pad from the sides, the text box
            //border color
            TextField("Location", text: addReasonMessage == "userLocationUpdate" ? $userLocationString: $eventLocation.currentEventMetProspect)
                .textInputAutocapitalization(.never)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
        //TODO: Change the size of this textfield? make it larger and smaller too!
            //                .background(
            //                                RoundedRectangle(cornerRadius: 8)
            //                                    .stroke(Color.red, lineWidth: 1) // Change the color and line width as needed
            //                            )
            //change the border color here
            
            
            Button("OK") {
                //sets the viewModels currentEvent variable equal to the string entered
                eventLocation.currentEvent = userLocationString
                dismiss()
            }
        }
        
        
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}


//Ok, so


//I have a struc
