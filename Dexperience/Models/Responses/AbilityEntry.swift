//
//  AbilityEntry.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

nonisolated
struct AbilityEntry: Codable, Hashable, Sendable {

    let ability: PokemonSummary?
    let isHidden: Bool?
    let slot: Int?

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}
