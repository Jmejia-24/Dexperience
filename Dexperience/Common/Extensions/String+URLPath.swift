//
//  String+URLPath.swift
//  Dexperience
//
//  Created by Byron on 4/25/25.
//

import Foundation

extension String {

    var lastPathComponent: String? {
        guard var url = URL(string: self) else { return nil }

        if url.path.hasSuffix("/") {
            url.deleteLastPathComponent()
        }

        return url.lastPathComponent
    }
}
