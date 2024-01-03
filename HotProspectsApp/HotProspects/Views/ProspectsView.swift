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
    enum FilterType: String, CaseIterable, Identifiable {
        case all, uncontacted
        
        var id: Self { self }
    }
    
    ///enum with keywords to describe what the prospects can be sorted by.  The enum
    enum SortType {
        case name, recent //different ways to sort the list
    }
    
    
    ///using the prospects stored in the environment
    @EnvironmentObject var prospects: Prospects
    
    @EnvironmentObject var eventLocation: EventLocation
    
 
    @State private var ListeditMode = EditMode.inactive
    
    @State var searchFieldText = ""
    
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
    
    ///boolean value to determine if the QR code sheet is shown or not
    @State var isShowingScanner = false
    
    ///boolean used to show teh alert to a user allowing them to enter location details
    @State  var showAlert = false
    
    @State  var showAddLocationView = false
    
    ///list items that the user selects, in editing mode
    @State var selectedItems: Set<UUID> = []
    
    // the selected type of the user that is chosen in the control
    @State  var selectedFilter: FilterType = .all
    
    
    /// The styling of the added to contacts alert
    var addToContactsAlertStyle = AlertToast.AlertStyle.style(backgroundColor: Color.white, titleColor: nil, subTitleColor: nil, titleFont: nil, subTitleFont: nil)
    
    /// The user can tap on each list item which opens a sheet that displays the prospects contact information
    var body: some View {
        
        NavigationView {
 
            //show Location
            //The list displays a vertical row of `ItemRow` views.
            VStack {
                
                
                SearchBarView(text: $searchFieldText)
                
                List(selection: $selectedItems) {
                    
                    ForEach(searchedfilteredProspects) {prospect in
                        Section {
                            ItemRow(prospect: prospect, filter: selectedFilter, toast: $presentToast)
                                .frame(height:100)
                                .padding(20)
                                .onTapGesture {
                                    
                                    currentSelectedProspect = Prospect(name: prospect.name, emailAddress: prospect.emailAddress, phoneNumber: prospect.phoneNumber)
                                    currentSelectedProspect.id = prospect.id
                                    currentSelectedProspect.locationMet = prospect.locationMet
                                    
                                    //                                print("Prospect tapped lcoation",prospect.locationMet)
                                    //                                print("Both ids match?",  currentSelectedProspect.id == prospect.id)
                                    
                                    showEditScreen = true
                                    
                                }
                               
                        }
                            .contextMenu {
                                
                                Button {
                                    //TODO: Add code here eventually for contacts storage
                                    
                                    saveProspectToContacts(email: prospect.emailAddress, phoneNumber: prospect.phoneNumber, name: prospect.name, locationMet: prospect.locationMet) { result in
                                        if(result) {
                                            presentToast = true
                                        }
                                    }
                                } label: {
                                    Label("Add to Contacts", systemImage: "plus")
                                }
                            }
                    }
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.clear))
                    .listRowInsets(EdgeInsets())
                }
              
                

            }
            .navigationTitle("Prospects")
            
            //
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    editButton
                    
                }

                ToolbarItem(placement: .principal) {
                    Picker("",selection: $selectedFilter) {
                        ForEach(FilterType.allCases) { segment in
                            Text(segment.rawValue)
                                .tag(segment)
                        }
                    }
                    .frame(width:200, height:50)
                    .pickerStyle(.segmented)
                    
                    
                    
//                    ProspectSegmentView(selectedSegment: $selectedFilter)
//                        .frame(width: 150)
                }

                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    //
                    if(ListeditMode == .active) {
                        Button("Delete") {
                            deleteItems()
                            
                            
                        }.disabled(selectedItems.isEmpty)
                    } else {
                        
                        toolbarButton("", systemImage: "qrcode.viewfinder") {
                            isShowingScanner = true
                        }
                        
                        
                        
                        Menu {
                            Button((self.sort == .name ? "✓ " : "") + "Name") {
                                self.sort = .name //will refresh the UI based on this
                            }
                            Button((self.sort == .recent ? "✓ " : "") + "Recent") {
                                self.sort = .recent //will refresh the UI based on this
                            }
                        }label: {
                            Label("", systemImage: "arrow.up.arrow.down.circle")
                        }
                        //}
                    }
                    
                }
            }
            .environment(\.editMode, $ListeditMode)
            
            
            //display a sheet to show the scanner for the QR code.
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes:[.qr] , simulatedData: "Nana Bonsu\nNbonsu2000@gmail.com\n6467012471" ,completion: handleScan)
                
            }
            .sheet(isPresented: $showEditScreen, onDismiss:  updateProspect) {
                EditProspectDetailsView(prospect: $currentSelectedProspect)
                
            }
            
            
            //sheetshown when you add a new prospect via scanning
            .sheet(isPresented: $showAddLocationView, onDismiss: addNewProspectToProspects) {
                UserAndProspectLocationView(addReasonMessage:"prospectLocation")
                    .presentationDetents([.fraction(0.4)])
            }
            
            .sheet(isPresented: $eventLocation.changeEvent) {
                UserAndProspectLocationView(addReasonMessage:"userLocationUpdate")
                    .presentationDetents([.fraction(0.5 )])
                
            }
            
            //overlays a view on the screen, if there are no prospects saved
            .overlay(viewtoOverlay, alignment: .center)
            
            .toast(isPresenting: $presentToast) {
                
                AlertToast(displayMode: .banner(.slide), type: .complete(Color.green), title: "Saved to contact", style: Optional(addToContactsAlertStyle))
                
            }
            
        }
            .minimumScaleFactor(0.4)
        
            .onChange(of: selectedFilter) { newVal in
               print(newVal)
            }
    }

      private var editButton: some View {
           Button(action: {
               // Toggle edit mode
               ListeditMode = ListeditMode == .inactive ? .active : .inactive
              
           }) {
               Text(ListeditMode.isEditing ? "Done" : "Edit")
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
 
    
    
}

/// View that displays a textfeild for a user to add a location or event they met a prospect at.
///
///  This view is displayed inside of a detented sheet.


struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView()
            .environmentObject(Prospects())
            .environmentObject(EventLocation())
    }
}


//Ok, so


//I have a struc
