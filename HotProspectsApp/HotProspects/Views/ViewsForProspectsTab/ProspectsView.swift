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
    
    /// filters prospects based on whether a user has contacted them or not
    enum FilterType: String, CaseIterable, Identifiable {
        case all, uncontacted // all will display both contacted and uncontacted prospects
        
        var id: Self { self }
    }
    
    ///enum with keywords to describe what the prospects can be sorted by.  The enum
    enum SortType {
        case name, recent //different ways to sort the list
    }
    
    
    ///using the prospects stored in the environment
    ///
    @EnvironmentObject var prospects: Prospects
    
    @EnvironmentObject var eventLocation: EventLocation
    
    @Environment(\.dismiss) var dismiss
    
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
    
    /// items that the user selects, in editing mode
    @State var selectedItems: Set<UUID> = []
    
    // the selected type of the user that is chosen in the control
    @State  var selectedFilter: FilterType = .all
    
    @State var showNoSearchView = false
    
    @State private var showDeleteAlert: Bool = false
    @State var showreminderSheet = false
    
    
    /// The styling of the added to contacts alert
    var addToContactsAlertStyle = AlertToast.AlertStyle.style(backgroundColor: Color.white, titleColor: nil, subTitleColor: nil, titleFont: nil, subTitleFont: nil)
    
    /// The user can tap on each list item which opens a sheet that displays the prospects contact information
    var body: some View {
  
        NavigationView {
            
            //show Location
            //The list displays a vertical row of `ItemRow` views.
            ZStack {
                VStack {
                    SearchBarView(text: $searchFieldText)
                    
                    //List displays `ItemRow` views vertically in sections. The sections ar  used to visually seperate the views from each other
                    prospectList
                }
                .onChange(of: searchFieldText, perform: { _ in
                    
                    if(searchedfilteredProspects.isEmpty){
                        showNoSearchView = true
                    } else {
                        showNoSearchView = false
                    }
                })
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
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        //
                        if(ListeditMode == .active) {
                            Button("Delete") {
                                deleteItems()
                                
                                
                            }.disabled(selectedItems.isEmpty)
                        } else {
                            
                            
                            
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
       
                    NavigationView {
                        VStack(spacing: 50) {
                            
                            CodeScannerView(codeTypes:[.qr] , simulatedData: "Nana Bonsu\nNbonsu2000@gmail.com\n6467012471" ,completion: handleScan)
                                .frame(width: 500, height: 370)
                                .padding([.top],0)
                            
                            
                            Text("Position your QR code within the frame to quickly save this prospects contact information")
                                .font(.title)
                                .padding()
                        }
                        .navigationTitle("Scan")
                        .navigationBarTitleDisplayMode(.inline)
                        
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Cancel") {
                                    isShowingScanner = false
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                }
                // Sheet to show the edit prospect details screen
                .sheet(isPresented: $showEditScreen, onDismiss:  updateProspect) {
                    EditProspectDetailsView(prospect: $currentSelectedProspect)
                    
                }
                
                // Sheet that displays view to add location a user meets a prospect and add notes about that prospect
                .sheet(isPresented: $showAddLocationView, onDismiss: addNewProspectToProspects) {
                    UserAndProspectLocationView(addReasonMessage:"prospectLocation")
                        .presentationDetents([.fraction(0.7)])
                }
                .overlay(noSearchResultsView, alignment: .center)
                
                //overlays a view on the screen if there are no prospect saved
                .overlay(viewtoOverlay, alignment: .center)
                
                .toast(isPresenting: $presentToast) {
                    
                    AlertToast(displayMode: .banner(.slide), type: .complete(Color.green), title: "Saved to contact", style: Optional(addToContactsAlertStyle))
                    
                }
                
                FloatingButtonView(showScanner: $isShowingScanner)
            }
        }
        .minimumScaleFactor(0.4)
 
    }
    
    /// Defines the list of added Prospects.
    ///
    /// `ProspectList' displays a list of `ItemRow` views. An `ItemRow` contains details about the location and time the user meets a prospect.
    var prospectList: some View {
        
        List(selection: $selectedItems) {
            
            ForEach(searchedfilteredProspects) {prospect in
                
                Section {
                    ItemRow(prospect: prospect, toast: $presentToast, filter: selectedFilter)
                        .frame(height:100)
                        .padding(20)

                        .onTapGesture {
                          //this is to edit
                            currentSelectedProspect = Prospect(name: prospect.name, emailAddress: prospect.emailAddress, phoneNumber: prospect.phoneNumber)
                            currentSelectedProspect.id = prospect.id
                            currentSelectedProspect.locationMet = prospect.locationMet
                            currentSelectedProspect.prospectNotes = prospect.prospectNotes
                            currentSelectedProspect.linkedinProfileURL = prospect.linkedinProfileURL
                            currentSelectedProspect.discordUsername = prospect.discordUsername
                            
                            showEditScreen = true //displays the edit screen
                        }
                        .contextMenu {
                            Button {
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
            }
            
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.clear))
            .listRowInsets(EdgeInsets())
            
        }
        .listStyle(.insetGrouped)
    }
    
    
 
    private var editButton: some View {
        Button(action: {
            // Toggle edit mode when the user presses on the button
            ListeditMode = ListeditMode == .inactive ? .active : .inactive
            
        }) {
            Text(ListeditMode.isEditing ? "Done" : "Edit")
        }
    }
    
    
    /// overlays the view when there are no prospects
    var viewtoOverlay: some View {
        if(prospects.people.isEmpty) {
            return AnyView(
                VStack(spacing:10) {
                    Text("No Prospects Saved")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    Text("Press the \(Image(systemName: "qrcode.viewfinder")) button to scan a Prospect's QR code")
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray)
                }
            )
        } else  {
            return AnyView(EmptyView())
        }
    }
    
    var noSearchResultsView: some View {
        
        if showNoSearchView {
            return AnyView(SearchUnavailableView(searchPhrase: $searchFieldText))
        } else {
            return AnyView(EmptyView())
        }
        
    }
    
    //here have the QRcode thing for the view!
    
    
    
}

//will make a struct that has the desired view for the QR code


struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView()
            .environmentObject(Prospects())
            .environmentObject(EventLocation())
    }
}


