//
//  AbilityEntry.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

struct AbilityEntry: Codable, Hashable {

    let ability: PokemonSummary?
    let isHidden: Bool?
    let slot: Int?

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}
