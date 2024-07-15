//
//  PrivacyPolicyView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 5/7/24.
//

import Foundation
import SwiftUI


struct PrivacyPolicyView: View {
    
    @State private var showWebView:Bool = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                
                Text("""
                Data Collection: We collect personal information like email addresses, names, and phone numbers, as well as usage data like IP addresses and browser information, to provide and improve our service.

                Data Usage: We use personal data to manage user accounts, provide customer support, send updates and notifications, and offer relevant products and services. We also analyze data for business purposes like improving our service and marketing efforts.

                Data Sharing: We may share personal information with service providers, affiliates, business partners, and in certain business transactions or legal circumstances.

                Data Security: While we strive to protect user data, we cannot guarantee absolute security.

                Children's Privacy: Our service is not directed at individuals under the age of 13, and we do not knowingly collect personal information from them without parental consent.

                Changes to Policy: We may update our privacy policy periodically, and users will be notified of any changes.

                For more details, please review the full privacy policy by clicking the button below.
                
                
                """)
                .font(.body)
                
                Button("View Full Policy"){
                    showWebView = true
                }
            }
            .padding()
            .sheet(isPresented: $showWebView) {
                SafariView(url: (URL(string: "https://www.termsfeed.com/live/1ebead17-c846-4bf3-960b-3c475e991450")!))
            }
        }
        .navigationBarTitle("Privacy Policy", displayMode: .inline)
    }
}
