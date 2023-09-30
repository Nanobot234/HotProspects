//
//  MeView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 9/11/23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    
    @EnvironmentObject private var viewModel:RowModel
    @State private var name = "Nana Bonsu"
    @State private var emailAddress = "Nbonsu2000@gmail.com"
    @State private var phoneNumber = "6467012471"
    @State private var qrCode = UIImage()
    
    let context = CIContext() //context for core image things
    let filter = CIFilter.qrCodeGenerator()
    
    //Need to make a header for the form, and
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Personal Info")) {
                    TextField("Name",text: $name)
                        .textContentType(.name)
                        .font(.title)
                    
                    TextField("Email Address", text: $emailAddress)
                        .textContentType(.emailAddress)
                        .font(.title)
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .textContentType(.telephoneNumber)
                        .font(.title)
                    
                }
                Section(header: Text("My QR Code").bold()) {
                    HStack {
                        Image(uiImage: qrCode)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .contextMenu {
                                Button {
                                    
                                    let imageSaver = ImageSaver()
                                    imageSaver.writeToPhotoAlbum(image: qrCode)
                                } label: {
                                    Label("Save to Photos", systemImage: "square.and.arrow.down")
                                }
                            }
                        
                        Image(systemName: "square.and.arrow.down")
                    }
                }
                //now will add ability to ssave photos
                    
                    
            }
            .navigationTitle("Your Info")
            .onAppear(perform: updateCode)
            .onChange(of: name) {_ in updateCode()}
            .onChange(of: emailAddress) {_ in updateCode()}
            .onChange(of: phoneNumber) {_ in updateCode()} //??
            .onChange(of: viewModel.currentLocation, perform: {_ in updateCode()})
        }
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)\n\(phoneNumber)\n\(viewModel.currentLocation)")
    }
    
    func generateQRCode(from string:String) -> UIImage {
        filter.message = Data(string.utf8) // puts the filter inside

        ///
        ///
            if let outputImage = filter.outputImage {
                if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                    qrCode = UIImage(cgImage: cgimg) //cashing it to be saved
                    return qrCode
                }
            }

            return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
