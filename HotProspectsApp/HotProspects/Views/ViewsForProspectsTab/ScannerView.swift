//
//  ScannerView.swift
//  HotProspects
//
//  Created by Nana Bonsu on 7/29/24.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {
    
    
    enum  ScreenType: String, CaseIterable, Identifiable {
        case scan, qrCode
        
        var id: Self { self }
    }
    
    @Environment(\.dismiss) var dismiss
    
    
    var handleScan: (Result<ScanResult, ScanError>) -> Void
    @State private  var filter: ScreenType = .scan
    @State private var qrCodeImage: UIImage = UIImage()
    @State private var originalBrightness: CGFloat = 0.0
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                
                if filter  == .scan {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Nana Bonsu\nNbonsu2000@gmail.com\n6467012471", completion: handleScan)
                        .frame(width: 500, height: 370)
                        .padding(.top, 0)
                    Text("Position your QR code within the frame to quickly save this prospect's contact information")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Image(uiImage: qrCodeImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .onAppear {
                            if let screen = SceneManager.shared.windowScene?.screen {
                                            // Save the current brightness level
                                            originalBrightness = screen.brightness
                                            // Set brightness to maximum
                                            screen.brightness = 1.0
                                        }
                        }
                        .onDisappear {
                                    if let screen = SceneManager.shared.windowScene?.screen {
                                        // Restore the original brightness level
                                        screen.brightness = originalBrightness
                                    }
                                }
                }
            }
            .navigationTitle("Scan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                       dismiss()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $filter) {
                        ForEach(ScreenType.allCases) { segment in
                            if segment == .scan{
                                Text("Hello")
                            }
                            if segment == .qrCode {
                                Text("My QR Code")
                            }
                        }
                    }
                    .frame(width: 200, height: 50)
                    .pickerStyle(.segmented)
                }
            }
        }
        .onAppear {
            qrCodeImage = loadImageFromUserDefaults() ?? UIImage()
            
           
            
        }
    }
    
    private func loadImageFromUserDefaults() -> UIImage? {
          if let data = UserDefaults.standard.data(forKey: "qrCode"),
             let image = UIImage(data: data) {
              return image
          }
          return nil
      }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(handleScan: { result in
            // Handle the scan result in the preview
        })
    }
}


class SceneManager {
    static let shared = SceneManager()
    
    var windowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
}
