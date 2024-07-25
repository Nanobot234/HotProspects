//
//  MeViewModel.swift
//  HotProspects
//
//  Created by Nana Bonsu on 6/12/24.
//

import Foundation
import UIKit


class MeViewModel: ObservableObject {
    
    
    
    let filter = CIFilter.qrCodeGenerator()
    let context = CIContext()
    
    
    @Published var name = "" {
        didSet {
            UserDefaults.standard.set(name, forKey: "users_name")
        }
    }
    
    @Published var emailAddress = "" {
        didSet {
            UserDefaults.standard.set(emailAddress, forKey: "users_email")
        }
    }
    @Published var phoneNumber = "" {
        didSet {
            UserDefaults.standard.set(phoneNumber, forKey: "users_phone")
        }
    }
    
    @Published var discordUsername = "" {
        didSet {
            UserDefaults.standard.set(phoneNumber, forKey: "discord_username")
        }
    }
    
    @Published var linkedinUsername = "" {
        didSet {
            UserDefaults.standard.set(linkedinUsername, forKey: "linkedin_username")
        }
    }
    
    @Published  var nameCopy = "" {
        didSet {
            UserDefaults.standard.set(nameCopy, forKey: "users_name_copy")
        }
            //TODO: Change the rest here. 
    }
    @Published  var emailAddressCopy = "" {
        didSet {
            UserDefaults.standard.set(emailAddressCopy, forKey: "users_email_copy")
        }
    }
    @Published  var phoneNumberCopy = "" {
        didSet {
            UserDefaults.standard.set(phoneNumberCopy, forKey: "users_phone_copy")
        }
     
    }
    @Published  var linkedinUsernameCopy = "" {
        didSet {
            UserDefaults.standard.set(linkedinUsernameCopy, forKey: "Linkedin_Username_copy")
        }
       
    }
    @Published  var discordUsernameCopy = "" {
        didSet {
            UserDefaults.standard.set(discordUsernameCopy, forKey: "Discord_Username_copy")
        }
    }
    ///  a boolean that determines if the share view controller will be shown
    @Published var showShareActivity: Bool = false
    
    /// The url link containing the contact information that will be shared with other apps!
    @Published var contactFileURL: URL? = nil
    
    init() {
        loadUserInfo()
    }
    
    
    func loadUserInfo() {
        
        name = UserDefaults.standard.string(forKey: "users_name") ?? ""
        emailAddress = UserDefaults.standard.string(forKey: "users_email") ?? ""
        phoneNumber = UserDefaults.standard.string(forKey:"users_phone") ?? ""
        linkedinUsername = UserDefaults.standard.string(forKey: "linkedin_username") ?? ""
        discordUsername = UserDefaults.standard.string(forKey: "discord_username") ?? ""
        
        nameCopy = UserDefaults.standard.string(forKey: "users_name_copy") ?? ""
        emailAddressCopy = UserDefaults.standard.string(forKey: "users_email_copy") ?? ""
        phoneNumberCopy = UserDefaults.standard.string(forKey: "users_phone_copy") ?? ""
        linkedinUsernameCopy = UserDefaults.standard.string(forKey: "Linkedin_Username_copy") ?? ""
        discordUsernameCopy =  UserDefaults.standard.string(forKey: "Discord_Username_copy") ?? ""
           
    }
    
    func generateQRCode(from string:String, with qrCode: UIImage?) -> UIImage {
        filter.message = Data(string.utf8) // puts the filter inside

            var targetQRCode = qrCode
            if let outputImage = filter.outputImage {
                if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                    targetQRCode = UIImage(cgImage: cgimg) //cashing it to be saved
                    return  targetQRCode!
                }
            }

            return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
    func shareMyInfo() {
        let vCardString = createVCardFromProspect()
        if let vCardString = vCardString {
            if let fileURL = saveVCardAndGetFileURL(vCardString: vCardString) {
                contactFileURL = fileURL
                showShareActivity = true
            }
        }
    }
    
  
    
    
    //change this here, needs to be with userdetails!!
    func createVCardFromProspect() -> Data? {
        // Get details from user defaults or other sources
        let vCardString = """
        BEGIN:VCARD
        VERSION:3.0
        FN:\(self.name)
        TEL;TYPE=CELL:\(self.phoneNumber)
        EMAIL:\(self.emailAddress)
        URL;TYPE=LinkedIn:\(self.linkedinUsername)
        URL;TYPE=Discord:\(self.discordUsername)
        END:VCARD
        """.data(using: .utf8)
        return vCardString
    }

    
    /// creates a shareable url for a vCard file
    /// - Parameter vCardString: the string decribing the contents of the vCard
    /// - Returns: the url
    func saveVCardAndGetFileURL(vCardString: Data) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = "contact.vcf"
        let fileURL = tempDirectory.appendingPathComponent(fileName)

        do {
            try vCardString.write(to: fileURL)
            return fileURL
        } catch {
            print("Failed to save vCard file: \(error)")
            return nil
        }
    }
    
}
