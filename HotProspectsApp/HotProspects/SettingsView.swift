//
//  AboutAppView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/15/24.
//

import SwiftUI
import LocalAuthentication

/// Contains privacy info, FAQs , etc
struct SettingsView: View {
    
    
//    @Environment(\.isBioAuthenticated) private var isAuthenticated
//
   // @State private var isUnlocked = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State var isBioAuthEnabled = false
    @State var meTabDescription = ""
    let propectsTabDescription = "In the Prospects tab, use the blue icon on the bottom right of the prspects page to scan a prospects QR code and you will instantly have access to all the contact info they share with you."
    let profileTabDescription = "In the profile tab, update your contact information and easily choose which one you want to share with prospects. Then click on the My QR Code button to display a QR code that others can scan to save your information"
    

    var body: some View {
        //NavigatioNView here!!
        NavigationStack {
            
            Form {
                Section {
                    HStack {
                        
                        Image(systemName:"faceid")
                        Toggle(isOn: $isBioAuthEnabled) {
                            Text("Face ID") //TODO: Add functionality for FACEID here, or touch
                        }
                        
                        
                    }
                } header: {
                    Text("Preferences")
                }
                
                
                Section {
                    //Help Section here
                    
                    //                NavigationLink(destination: Text(), label: <#T##() -> View#>)
                    
                    NavigationLink(destination: appTabDscription){
                        Text("Questions or Comments? Email me")
                    }
                    //button to show a mailView
//                    Button("Questions or Comments?") {
//                        //then mail code here
//
//                    }
                    NavigationLink(destination: appTabDscription){
                        Text("How to use this app")
                    }
                    
                    
                    //Questions send email
                    //Have ideas comments
                } header: {
                    Text("Need Help?")
                }
                //m aybe add linkedin and sign in info here
                
                Section {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("Privacy Policy")
                    }
                    
                } header: {
                    Text("Legal")
                }
                
            }
            .onChange(of: isBioAuthEnabled, perform: { newValue in
                
                //when you toggle on
                if newValue {
                    authenticate()
                }
            })
            .navigationTitle("Settings")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                //some error here!!
            }
        }
        
        
    }
    
    var appTabDscription: some View {
        //mored details here
        VStack {
            VStack {
                
                Label("Prospects", systemImage: "person.3")
                
                Text(propectsTabDescription)
                    .padding([.bottom], 20)
            }
            
            VStack {
                Label("Me", systemImage: "person.crop.square")
                Text(profileTabDescription)
            }
    }
    }
    
    func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authenticate to access your account"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            isBioAuthEnabled
                        } else {
                            alertMessage = authenticationError?.localizedDescription ?? "Authentication failed"
                            showingAlert = true
                        }
                    }
                }
            } else {
                // Biometry not available
                alertMessage = error?.localizedDescription ?? "Biometry not available"
                showingAlert = true
            }
        }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
