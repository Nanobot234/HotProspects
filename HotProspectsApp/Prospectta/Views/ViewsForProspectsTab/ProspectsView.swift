import CodeScanner
import Contacts
import SwiftUI
import UserNotifications


struct ProspectsView: View {
    
    enum FilterType: String, CaseIterable, Identifiable {
        case all, uncontacted
        
        var id: Self { self }
    }
    
    enum SortType {
        case name, recent
    }
    
    //addContacts
    enum ActiveSheet: Identifiable {
        case scanner, edit, addLocation, reminder
        
        var id: Int {
            hashValue
        }
    }
    
    @EnvironmentObject var prospects: Prospects
    @EnvironmentObject var eventLocation: EventLocation
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    
    @State var ListeditMode = EditMode.inactive
    @State var searchFieldText = ""
    /// The prospect that is added to the list after the user scans a qr code
    @State var newProspect = Prospect()
    
    @State var currentSelectedProspect: Prospect? = nil
    
    @State var showEditScreen = false
    @State var sort: SortType = .name
    @State var presentToast = false
    @State var selectedItems: Set<UUID> = []
    @State var selectedProspectID: UUID?
    
    @State var selectedFilter: FilterType = .all
    @State var showNoSearchView = false
    @State var showDeleteAlert: Bool = false
    @State var activeSheet: ActiveSheet?
    
    /// boolean to determine if a dialog should be shown when the user successfully adds a contact
    @State var showContactDialog: Bool = false
    
    /// Determines whether the app is allowed to access the users contacts
    @State var hasContactsAccess: Bool = false
    
  //  var addToContactsAlertStyle = AlertToast.AlertStyle.style(backgroundColor: Color.white, titleColor: nil, subTitleColor: nil, titleFont: nil, subTitleFont: nil)
    
    var body: some View {
            NavigationView {
                ZStack {
                    VStack {
                        SearchBarView(text: $searchFieldText)
                        prospectList
                        
                        
                    }
                    .onChange(of: searchFieldText) { _ in
                        showNoSearchView = searchedfilteredProspects.isEmpty
                    }
                    .navigationTitle("Prospects")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            editButton
                        }
                        ToolbarItem(placement: .principal) {
                            Picker("", selection: $selectedFilter) {
                                ForEach(FilterType.allCases) { segment in
                                    Text(segment.rawValue).tag(segment)
                                }
                            }
                            .frame(width: 200, height: 50)
                            .pickerStyle(.segmented)
                        }
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            if ListeditMode == .active {
                                Button("Delete") {
                                    deleteItems()
                                }
                                .disabled(selectedItems.isEmpty)
                            } else {
                                Menu {
                                    Button((self.sort == .name ? "✓ " : "") + "Name") {
                                        self.sort = .name
                                    }
                                    Button((self.sort == .recent ? "✓ " : "") + "Recent") {
                                        self.sort = .recent
                                    }
                                } label: {
                                    Label("", systemImage: "arrow.up.arrow.down.circle")
                                }
                            }
                            
                            
                        }
                    }
                    .environment(\.editMode, $ListeditMode)
                    
                    // MARK: Sheet modifiers for the view
                    .sheet(item: $activeSheet, onDismiss: saveNewProspectWithDetails) { item in
                        switch item {
                        case .scanner:
                            ScannerView(handleScan: handleScan)
                        case .edit:
                            EditProspectDetailsView(prospect: $currentSelectedProspect)
                        case .addLocation:
                            UserAndProspectLocationView(addReasonMessage: "prospectLocation" )
                                .presentationDetents([.fraction(0.7)])
                                .onDisappear(perform: addNewProspectToProspects)
                        case .reminder:
                            // Your reminder view here
                            EmptyView()
                            
                        }
                    }
                    .overlay(noSearchResultsView, alignment: .center)
                    .overlay(viewToOverlay, alignment: .center)
                    //                .toast(isPresenting: $presentToast) {
                    //                    AlertToast(displayMode: .banner(.slide), type: .complete(Color.green), title: "Saved to contact", style: addToContactsAlertStyle)
                    //                }
                    //checks if the current active slection is for the scanner. If so will select it!
                    
                    
                    FloatingButtonView(showScanner: Binding(get: {
                        activeSheet == .scanner
                    }, set: { value in
                        activeSheet = value ? .scanner : nil
                    }))
                    
                    if eventLocation.addedProspectToContacts {
                        SuccessDialog(imageToPresent: "person.crop.circle.badge.checkmark", text: "Added to Contacts")
                            .transition(.opacity)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                                    withAnimation {
                                        eventLocation.addedProspectToContacts = false
                                    }
                                }
                            }
                    }
                }
                
               
            }
        .tint(Color.cyan)
        .minimumScaleFactor(0.4)
        
        .onAppear {
            requestContactsAccess { granted in
                hasContactsAccess = granted
            }
           
        }
    }
    
    var prospectList: some View {
        List(selection: $selectedItems) {
            
            ForEach(searchedfilteredProspects) { prospect in
                Section {
    
                    
                    ItemRow(prospect: prospect, canAccessUsersContacts: $hasContactsAccess, setContactDialog: $showContactDialog, tappedProspectID: $selectedProspectID,  filter: selectedFilter)
                        .frame(maxHeight: 200)
                        .padding(20)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .foregroundStyle(.primary)
                        .contentShape(Rectangle()) // Makes the whole area tappable
                        .onTapGesture(count: 1){
                            print("This prospect id:\(prospect.prospectID)")
                            currentSelectedProspect = prospect
                            
                            //conditional check to see if currentSelectedProspect isnt nill
                            if let selectedProspect = currentSelectedProspect {
                                //Prospect(id: prospect.id, name: prospect.name, emailAddress: prospect.emailAddress, phoneNumber: prospect.phoneNumber, locationMet: prospect.locationMet, prospectNotes: prospect.prospectNotes)
                                print("The selected prospect id:\(selectedProspect.prospectID)")
                                print("The location of the prospect ur tapping: \(currentSelectedProspect!.locationMet)")
                                activeSheet = .edit
                                selectedProspectID = nil
                            }
                        }
                }
            }
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.clear))
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.insetGrouped)
    }
    
    func requestContactsAccess(completion: @escaping (Bool) -> Void) {
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to request access:", error)
                    completion(false)
                    return
                }
                
                completion(granted)
            }
        }
    }
    
    func saveNewProspectWithDetails() {
        
        if(activeSheet == .addLocation) {
            addNewProspectToProspects()
        }
    }
    
    private var editButton: some View {
        Button(action: {
            ListeditMode = ListeditMode == .inactive ? .active : .inactive
        }) {
            Text(ListeditMode.isEditing ? "Done" : "Edit")
        }
    }
    
    
    var viewToOverlay: some View {
        if prospects.people.isEmpty {
            return AnyView(
                VStack(spacing: 10) {
                    Text("No Prospects Saved")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    Text("Press the \(Image(systemName: "qrcode.viewfinder")) button to scan a Prospect's QR code")
                        .font(.system(size: 20))
                        .foregroundColor(Color.gray)
                }
            )
        } else {
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
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView()
            .environmentObject(Prospects())
            .environmentObject(EventLocation())
    }
}

