//
//  PokemonVariety.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

struct PokemonVariety: Codable {
    let isDefault: Bool?
    let pokemon: PokemonSummary?

    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case pokemon
    }
}
