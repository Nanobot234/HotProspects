//
//  FloatingButtonView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/3/24.
//

import SwiftUI

struct FloatingButtonView: View {
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
                                print("FAB tapped")
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                                    .background(Color.green)
                                    .clipShape(Circle())
                            }
                            .padding(20)
                        }
                    }
                    .padding(.bottom,60)
                
               
    }
}

struct FloatingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButtonView()
            .environmentObject(EventLocation())
    }
}
