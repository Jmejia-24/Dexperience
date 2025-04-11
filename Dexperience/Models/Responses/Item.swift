//
//  Item.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//


struct Item: Codable {

    let id: Int?
    let name: String?
    let cost: Int?
    let sprites: Sprites?
    let effectEntries: [EffectEntry]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cost
        case sprites
        case effectEntries = "effect_entries"
    }
}

struct EffectEntry: Codable {

    let effect: String?

    enum CodingKeys: String, CodingKey {
        case effect
    }
}
