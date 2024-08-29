//
//  ActionDialog.swift
//  Prospecta
//
//  Created by Nana Bonsu on 8/23/24.
//

import SwiftUI

struct SuccessDialog: View {

    var imageToPresent: String
    var text: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageToPresent) // Replace with your image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 50)
                .foregroundColor(.gray)

            Text(text)
                .font(.headline)
                .foregroundColor(.black)
        }
        .frame(width: 150, height: 180)
       
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
       
    }
}
#Preview {
    SuccessDialog(imageToPresent: "hammer.fill", text:"Build Succeeded")
}
