//
//  String+Formatted.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//

extension String {

    var formatted: String {
        self
            .replacingOccurrences(of: "-", with: " ")
            .capitalized
    }
}
