//
//  EditProspectDetailsView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 5/6/24.
//



import SwiftUI
import SafariServices
import MessageUI


/// Screen that displays prospect details and allow
struct EditProspectDetailsView: View {
    
    
    @Environment(\.dismiss) var dismiss
    
     @Binding var prospect: Prospect? //make this a binding changes would reflect, in previously but not on memory. Can
    
    @EnvironmentObject var eventLocation: EventLocation //seeign the current event
    @EnvironmentObject var prospects: Prospects
    
    @State private var selectedProspect = Prospect()
    /// The text for the location feild
    @State  var locationText: String = ""
    
    /// Notes that a user writes about the prospect they meet!
    @State var prospectNotesText: String = ""
    
    /// controls visibility of safari view for a persons Linkedin Profile
    @State var showWebView: Bool = false
    
    /// controls visbility of dialog displaying diffferent messaging that a user can contact a prospect in
    @State var showMessagingAppsDialog: Bool = false
    
    /// controls visibility of email creator view!
    @State var isShowingMailView = false
    
    
    ///  controls visiblity of of screen where a user can send an SMS message.
    @State var isShowingMessageView = false
    
   
    //MARK: UI Code
    var body: some View {
        NavigationView {
            Form {

                
                //TODO: Add spacing between form items and also between section header?
              
                    Section(header: Text("Update \(prospect!.name)'s contact information")) {
                        TextField(" Name", text: $selectedProspect.name)
                        
                        HStack {
                            //logo button here(beneath this)
                            TextField("Email Address", text: $selectedProspect.emailAddress)
                            Spacer()
                            Button("Send Email", systemImage: "paperplane") {
                                isShowingMailView = true
                                
                            }
                            .labelStyle(.iconOnly)
                            .sheet(isPresented: $isShowingMailView, content: {
                                MailView(isShowing: $isShowingMailView, recpientEmail: prospect!.emailAddress)
                            })
                        }
                    
                    
                    HStack {
                        TextField("Phone Number", text: $selectedProspect.phoneNumber)
                        Spacer()
                        //action sheet somewhere here!!
                        
                        Button("Send Text", systemImage: "message") {
                                showMessagingAppsDialog = true
                        }
                        .labelStyle(.iconOnly)
                        .confirmationDialog("Chose the app you want to message in", isPresented: $showMessagingAppsDialog) {
                            Button("Messages") { isShowingMessageView = true}
                            Button("WhatsApp") {openWhatsAppMessage()}
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                    .sheet(isPresented: $isShowingMessageView, content: {
                        let message = "Hello, this is \(prospect!.name)!. We met at \(locationText)"
                        MessageView(isShowing: $isShowingMessageView, messageBody: message, phoneNumber: prospect!.phoneNumber)
                    })
                }
                
                //section ehre for updating location met
                Section {
                    TextField("Location or Event Where You Met This Prospect", text: $locationText)
                } header: {
                    Text("Location Where You Met This Prospect")
                }
                
                if(!prospect!.linkedinProfileURL.isEmpty){
                    
                    Section  {
                    
                    Button("View \(prospect!.name)'s LinkedIn") {
                        showWebView = true
                    }
                    //also have
                } header:
                {
                    Text("Socials")
                }
                    
            }
                if(!prospect!.discordUsername.isEmpty){
                    Section {
                        Text(prospect!.discordUsername)
                    } header: {
                        Text("\(prospect!.name)'s Discord")
                    }
                }
                //Different section for discord username and copy
                Section {
                    TextEditor(text: $prospectNotesText)
                        .frame(width: 200,height: 300)
                } header: {
                    Text("Notes about \(prospect!.name)")
                }
                
            }
            .onAppear {
                
                setProspectLocationandNotesFromEnvironment()
                print(prospect!.locationMet)
                print("Profile URL" + prospect!.linkedinProfileURL)
                
                guard let newselectedProspect = prospect else {
                    print("Invalid prospect")
                        
                    return
                }
                
                selectedProspect = newselectedProspect
                
            }
            .onDisappear {
                    prospect = nil
            }
                 //MARK: Toolbar UI elements
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button("Cancel") {
                        
                        dismiss()
                       // prospect = nil
                       
                        
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    //When user presses save, update propspext with changed values.
                    Button("Save") {
                        
                        //should check
                        prospect!.locationMet = locationText
                        prospects.addLocationMet(prospect!) //updates the environment array with this value
                        
                        prospect!.prospectNotes = prospectNotesText
                        prospects.addNotesForProspect(prospect!)
                        
                        //save all the updated details in the prospect
                        prospects.updateProspectDetails(prospect!)
                        
                        dismiss()
                       
                    }
                }
            }
            .sheet(isPresented: $showWebView, content: {
                SafariView(url: URL(string:prospect!.linkedinProfileURL)!)
            })
            
            .navigationTitle("Edit Contact Information")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }

    //MARK: functions for various tasks!
    /// sets the location and notes field for a particular user
    ///
    /// If the user didnt specifiy a location they met a prospect, then the current event they are attending is set as the location met.
    /// This fucntion is run when `onAppear` is called
    func setProspectLocationandNotesFromEnvironment() {
        //when u come in, should be loading waht is environment
 
        
        if(prospect!.locationMet == "") {
            locationText = eventLocation.currentEventOfUser //the event that the user is at. since its added automatically
        } else {
            locationText = prospect!.locationMet
        }
        
        
        prospectNotesText = prospect!.prospectNotes
    }
    
    /// Opens WhatsApp Messenger app for the specified phone number
    ///
    /// When the user clicks on the button, whatsapp will be opened with a prefilled message that can be edited at the user's discretion.
    func openWhatsAppMessage() {// Replace with the recipient's phone number
        let message = "Hello, this is \(prospect!.name)!. We met at \(locationText)"
                      
        if let url = URL(string: "https://wa.me/+1 \(prospect!.phoneNumber)?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
            
            UIApplication.shared.open(url)
        }
    }
}

//struct EditProspectDetailsView_Previews: PreviewProvider {
//
//    static var previews: some View {
//
//        @Binding var prospect = Prospect.example
//
//        prospect.emailAddress = "Nbonsu2000@gmail.com"
//        prospect.phoneNumber = "6467012471"
//
//        return EditProspectDetailsView(prospect: $prospect)
//    }
//}
