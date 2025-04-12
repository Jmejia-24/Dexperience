//
//  Move.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//

struct Move: Codable, Hashable {

    let id: Int?
    let name: String?
    let type: PokemonSummary?
    let effectEntries: [EffectEntry]?
    let accuracy: Int?
    let power: Int?
    let pp: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case effectEntries = "effect_entries"
        case accuracy
        case power
        case pp
    }
}
