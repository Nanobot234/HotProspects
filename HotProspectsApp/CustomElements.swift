//
//  CustomElements.swift
//  HotProspects
//
//  Created by Nana Bonsu on 7/22/24.
//

import SwiftUI

//Custom ui elements made in the app
struct confirmationButton: View {
    var title: String
    var actionToPerform: () -> Void //performs an action here

    var body: some View {
        Button {
            actionToPerform()
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .padding(.horizontal,40)
                //.shadow(radius: 5)
            //more here!!
        }
        .buttonStyle(.plain)

    }
}
struct CustomElements: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//  //  confirmationButton(title: <#String#>, actionToPerform: <#() -> Void#>)
//}
