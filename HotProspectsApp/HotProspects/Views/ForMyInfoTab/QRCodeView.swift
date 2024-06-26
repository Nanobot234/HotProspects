//
//  QRCodeView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/3/24.
//

import SwiftUI

struct QRCodeView: View {
    
    
    /// The qrCode image
    ///
    /// The qrCode is passed into this view as an optional `UIImage` object. The image might be nil if there are errors in the contact points of the user
    @State  var qrCodeImage: UIImage?
    
    /// indicates whether the user has decide to allow prospect to save email address
    @Binding var isSharingEmail:Bool
    
    /// indicates whether the user has decide to allow prospect to save email address
    @Binding var isSharingPhoneNum:Bool
    
    @State private var showPopover: Bool = false
    
    /// string that reminds the user what contact points are going to be shared with Prospects
    var contactSharingString : String {
        var finalString = "name "
        
        if(isSharingEmail == true){
            finalString += "email"
        }
        if(isSharingPhoneNum == true) {
            finalString += " phone number"
        }
        return finalString
    }
    
    var body: some View {
        
        
        if(qrCodeImage == nil) {
            Text("Cant generate QR Code. Make sure that your contact information doesn't contain any errors")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        VStack() {
            if let qrCodeImage = qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                //Add a Link Button
                
                Button {
                    
                    showPopover.toggle()
                } label: {
                    Label("About this QR Code", systemImage: "info.circle")
                        .font(.title2)
                        .underline(true)
                }

//
//                Text(" When someone scans this code, they will recieve your")
//                    .padding([.top],40)
//
//                Text(contactSharingString)
            }
        }
      
        .popover(isPresented: $showPopover, attachmentAnchor: .point(.bottom)){
            
            VStack(spacing:20) {
                Text("This QR code contains the contact information that will be shared with a prospect \n when they scan your code. ")
                    .font(.title3)
                Text("Your about to share" + contactSharingString)
                    .font(.title3)
                
            }
            .frame(width: 300, height: 200)
            
            .presentationCompactAdaptation(.popover)
        }
        
        
        .onDisappear {
            qrCodeImage = nil //should prevent any possible caching of the image
        }
        
    }
}
//
////TODO: need to review how the struct should work
//struct QRCodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        QRCodeView(qrCodeImage: UIImage(),isSharingEmail: false,isSharingPhoneNum: true)
//    }
//}
