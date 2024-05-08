//
//  FloatingButtonView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/3/24.
//

import SwiftUI

struct FloatingButtonView: View {
    
    @Binding var showScanner:Bool
    var body: some View {
                    // Your main content here
                    // Example background
                    
                    VStack {
                        Spacer() // Push the FAB to the bottom
                        
                        
                        HStack {
                            Spacer() // Push the FAB to the right
                            
                            Button(action: {
                                // Add your FAB action here
                                // This is a placeholder action
                                showScanner = true
                            }) {
                                Image(systemName: "")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .overlay(
                                            Image(systemName: "qrcode.viewfinder")
                                                .resizable()
                                                .frame(width: 40,height: 40)
                                                .foregroundColor(.white)
                                                
                                        )
                            }
                            .padding(20)
                        }
                    }
                    .padding(.bottom,30)
                
               
    }
}

struct FloatingButtonView_Previews: PreviewProvider {
    
    @State static var scanneVisible = false
   
    static var previews: some View {
        
        FloatingButtonView(showScanner: $scanneVisible)
            .environmentObject(EventLocation())
    }
}

