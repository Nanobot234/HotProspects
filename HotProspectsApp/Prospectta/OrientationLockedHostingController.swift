//
//  OrientationLockedHostingController.swift
//  HotProspects
//
//  Created by Nana Bonsu on 8/6/24.
//

import Foundation
import SwiftUI

class OrientationLockedHostingController<Content>: UIHostingController<Content> where Content: View {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}


