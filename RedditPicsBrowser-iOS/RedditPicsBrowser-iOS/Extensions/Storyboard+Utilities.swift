//
//  Storyboard+Utilities.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop Gunaga on 01/10/21.
//

import UIKit

enum StoryboardType: String {
    case main = "Main"
    case detail = "Detail"
}

extension UIStoryboard {
    static private func storyboard(ofType type: StoryboardType) -> UIStoryboard {
        return UIStoryboard(
            name: type.rawValue,
            bundle: nil)
    }
}

extension UIStoryboard {
    static func controller<T>(
        ofTpe type: String,
        storyboard: StoryboardType) -> T? where T: BaseViewController  {
        self.storyboard(ofType: storyboard).instantiateViewController(withIdentifier: type) as? T
    }
}
