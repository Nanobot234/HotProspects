//
//  SearchBarView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 11/28/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var text: String
    var body: some View {
        HStack {
            TextField("Search by name, email, phone, or date", text: $text)
                .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                        .transition(.move(edge: .trailing))
                        
                    }
                }
                .padding(.horizontal)
            }
    }


//struct SearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarView(text: "Hello World")
//            .environmentObject(EventLocation())
//    }
//}
