//
//  NSString+hashedFilename.swift
//  Dexperience
//
//  Created by Byron on 4/9/25.
//

import Foundation
import CryptoKit

extension NSString {

    func hashedFilename() -> String {
        let data = Data((self as String).utf8)
        let hash = Insecure.MD5.hash(data: data)

        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
