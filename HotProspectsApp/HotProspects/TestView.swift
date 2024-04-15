//
//  TestView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 3/29/24.
//

import SwiftUI
import Supabase

struct TestView: View {
    let client = SupabaseClient(supabaseURL: URL(string: "https://vvooyepqemtgjzktpalv.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ2b295ZXBxZW10Z2p6a3RwYWx2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTEzOTkyOTEsImV4cCI6MjAyNjk3NTI5MX0.8CkiZo0Zq5OLq8YWLAmGk3qSh8newTftqtBwadW8mCM")
    
    @State var authURL = URL(string: "")
    
    var body: some View {
        VStack {
            Text(authURL?.absoluteString ?? "You thought")
        }
        .onAppear{
            Task{
                authURL = try await client.auth .getOAuthSignInURL(provider: .linkedin)
            }
            
        }
    }
    

        
        
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
