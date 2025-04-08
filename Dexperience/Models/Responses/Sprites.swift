//
//  Sprites.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

struct Sprites : Codable, Hashable {
    let other: Other?

    enum CodingKeys: String, CodingKey {
        case other
    }
}
