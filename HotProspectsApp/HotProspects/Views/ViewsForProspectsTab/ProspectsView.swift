import CodeScanner
import Contacts
import SwiftUI
import UserNotifications
import AlertToast

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
    
    @State var ListeditMode = EditMode.inactive
    @State var searchFieldText = ""
    @State var newProspect = Prospect()
    @State var currentSelectedProspect = Prospect()
    @State var showEditScreen = false
    @State var sort: SortType = .name
    @State var presentToast = false
    @State var selectedItems: Set<UUID> = []
    @State var selectedFilter: FilterType = .all
    @State var showNoSearchView = false
    @State var showDeleteAlert: Bool = false
    @State var activeSheet: ActiveSheet?
    
    
    /// Determines whether the app is allowed to access the users contacts
    @State var hasContactsAccess: Bool = false
    
    var addToContactsAlertStyle = AlertToast.AlertStyle.style(backgroundColor: Color.white, titleColor: nil, subTitleColor: nil, titleFont: nil, subTitleFont: nil)
    
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
                .sheet(item: $activeSheet) { item in
                    switch item {
                    case .scanner:
                        NavigationView {
                            VStack(spacing: 50) {
                                CodeScannerView(codeTypes: [.qr], simulatedData: "Nana Bonsu\nNbonsu2000@gmail.com\n6467012471", completion: handleScan)
                                    .frame(width: 500, height: 370)
                                    .padding(.top, 0)
                                Text("Position your QR code within the frame to quickly save this prospect's contact information")
                                    .font(.title)
                                    .padding()
                            }
                            .navigationTitle("Scan")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Cancel") {
                                        activeSheet = nil
                                    }
                                }
                            }
                        }
                    case .edit:
                        EditProspectDetailsView(prospect: $currentSelectedProspect)
                    case .addLocation:
                        UserAndProspectLocationView(addReasonMessage: "prospectLocation")
                            .presentationDetents([.fraction(0.7)])
                            .onDisappear(perform: addNewProspectToProspects)
                    case .reminder:
                        // Your reminder view here
                        EmptyView()
                        
                    }
                }
                .overlay(noSearchResultsView, alignment: .center)
                .overlay(viewToOverlay, alignment: .center)
                .toast(isPresenting: $presentToast) {
                    AlertToast(displayMode: .banner(.slide), type: .complete(Color.green), title: "Saved to contact", style: addToContactsAlertStyle)
                }
                //checks if the current active slection is for the scanner. If so will select it!
                
                
                FloatingButtonView(showScanner: Binding(get: {
                    activeSheet == .scanner
                }, set: { value in
                    activeSheet = value ? .scanner : nil
                }))
            }
        }
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
                    ItemRow(prospect: prospect, canAccessUsersContacts: $hasContactsAccess, filter: selectedFilter)
                        .frame(maxHeight: 200)
                        .padding(20)
                    //                    .swipeActions(allowsFullSwipe: false) {
                    //                        swipeActionButtons(for: prospect)
                    //                    }
                    
                        .onTapGesture {
                            currentSelectedProspect = prospect
                            activeSheet = .edit //shows the edit screen! by choosing the ctive scanner!
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

