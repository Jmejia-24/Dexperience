//
//  Ability.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

struct Ability: Codable, Hashable {

    let name: String?
    let effectEntries: [EffectEntry]?

    enum CodingKeys: String, CodingKey {
        case name
        case effectEntries = "effect_entries"
    }
}
