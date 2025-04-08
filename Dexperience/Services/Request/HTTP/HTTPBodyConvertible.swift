//
//  HTTPBodyConvertible.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import Foundation

protocol HTTPBodyConvertible {
    var httpBody: Data? { get }
    var httpMethod: HTTPMethod { get }
}
