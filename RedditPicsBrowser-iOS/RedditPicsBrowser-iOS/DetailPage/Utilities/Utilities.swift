//
//  Utilities.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop on 02/10/21.
//

import Foundation
import Reachability

class Utilities {
    static var isInternetConnectivityAvailable: Bool {
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            return false
        }
        return true
    }
}
