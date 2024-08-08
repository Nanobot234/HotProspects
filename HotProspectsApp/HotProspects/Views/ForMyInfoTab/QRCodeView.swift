//
//  QRCodeView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 1/3/24.
//

import SwiftUI
import AlertToast

struct QRCodeView: View {
    
    /// The view from the ancestor!
    @EnvironmentObject var meViewModel : MeViewModel
    /// The qrCode image
    ///
    /// The qrCode is passed into this view as an optional `UIImage` object. The image might be nil if there are errors in the contact points of the user
    @State  var qrCodeImage: UIImage?
    
    /// indicates whether the user has decide to allow prospect to save email address
    @Binding var isSharingEmail:Bool
    
    /// indicates whether the user has decide to allow prospect to save email address
    @Binding var isSharingPhoneNum:Bool
    
    /// indicates whether the user has decide to allow prospect to save their discord userrname
    @Binding var isSharingDiscord: Bool
    
    /// 
    @Binding var isSharingLinkedin: Bool
    
    @State private var showPopover: Bool = false
    
    @State private var originalBrightness: CGFloat = 0.0
    
    @AppStorage("firstTimeLoading") var firstTimeLoading: Bool = false
    
    var updateQRCode: () -> Void
    
    var imageSaver = ImageSaver()
    
    var imageSaverAlertStyle = AlertToast.AlertStyle.style(backgroundColor: Color.white, titleColor: nil, subTitleColor: nil, titleFont: nil, subTitleFont: nil)
    
    /// string that reminds the user what contact points are going to be shared with Prospects
    var contactSharingString : String {
        var finalString = " name "
        
        if(isSharingEmail == true){
            finalString += " email "
        }
        if(isSharingPhoneNum == true) {
            finalString += " phone number "
        }
        
        if(isSharingLinkedin == true) {
            finalString += " Linkedin "
        }
        
        if(isSharingDiscord == true) {
            finalString += " Discord "
        }
        return finalString
    }
    
    //MARK: UI elements
    var body: some View {
        
        NavigationView {
          
            VStack() {
                
                if(qrCodeImage == nil) {
                    Text("Cant generate QR Code. Make sure that your contact information doesn't contain any errors")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                } else {
                    
                        Image(uiImage: qrCodeImage!)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                        
                        //Add a Link Button
                        
                        VStack {
                            Button {
                                showPopover.toggle()
                            } label: {
                                Label("About this QR Code", systemImage: "info.circle")
                                    .font(.title2)
                                    .underline(true)
                                    .backgroundStyle(Color.blue)
                            }
                            .background(Color.clear)
                            
                            Button {
                                meViewModel.shareMyInfo()
                            } label: {
                                Label("Share Your Contact", systemImage: "arrowshape.turn.up.right")
                                    .font(.title2)
                                    .underline(true)
                                    .backgroundStyle(Color.blue)
                            }
                            .background(Color.clear)
                        }
                    
                }
            }
            .sheet(isPresented: $meViewModel.showShareActivity) {
                ActivityViewController(activityItems: [meViewModel.contactFileURL!], isPresented: $meViewModel.showShareActivity)
                    .presentationDetents([.medium])
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", systemImage:"square.and.arrow.down") {
                        imageSaver.writeToPhotoAlbum(image: qrCodeImage!)
                    }

                }
            }
            .popover(isPresented: $showPopover, attachmentAnchor: .point(.bottom)){
                
                VStack(spacing:20) {
                    Text("This QR code contains the contact information that will be shared with a prospect \n when they scan your code. ")
                        .font(.title3)
                    Text("Your about to share your " + contactSharingString)
                        .font(.title3)
                    
                }
                .frame(width: 300, height: 200)
                
                .presentationCompactAdaptation(.popover)
            }
        }
        .onAppear {
           //gets the qrcode image from the viewModel which is updated in another view?
            
            //may run multiple times however?
            if firstTimeLoading {
              updateQRCode()
            }
            qrCodeImage = meViewModel.qrCode
            
            if let screen = SceneManager.shared.windowScene?.screen {
                            // Save the current brightness level
                            originalBrightness = screen.brightness
                            // Set brightness to maximum
                            screen.brightness = 1.0
                        }
        }
        
        .onDisappear {
            qrCodeImage = nil //should prevent any possible caching of the image
            
                            if let screen = SceneManager.shared.windowScene?.screen {
                                // Restore the original brightness level
                                screen.brightness = originalBrightness
                            }
                        
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
