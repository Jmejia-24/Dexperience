//
//  Pokemon.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import Foundation

struct Pokemon: Codable, Hashable {
    let id: Int?
    let name: String?
    let types: [TypeElement]?
    let sprites: Sprites?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case types
        case sprites
    }
}
