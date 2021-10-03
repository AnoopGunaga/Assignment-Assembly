//
//  String+Encode.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop Gunaga on 01/10/21.
//

import Foundation

extension String {
    func urlEncode() -> String? {
        let allowedCharacterSet = NSMutableCharacterSet.alphanumeric()
        allowedCharacterSet.addCharacters(in: "-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet as CharacterSet)
    }
}
