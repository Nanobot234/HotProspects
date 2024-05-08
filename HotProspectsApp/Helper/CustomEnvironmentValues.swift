//
//  CustomEnvironmentValues.swift
//  HotProspects
//
//  Created by Nana Bonsu on 5/8/24.
//

import Foundation
import SwiftUI

struct IsAuthenticatedKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    //bool that checks if the user has been biometrically authenticated!!
    var isBioAuthenticated: Bool {
        get {self[IsAuthenticatedKey.self]}
        set {self[IsAuthenticatedKey.self] = newValue}
    }
}


