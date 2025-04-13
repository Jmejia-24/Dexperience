//
//  PokemonStat.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

struct PokemonStat: Codable, Hashable {

    let baseStat: Int?
    let stat: PokemonSummary?

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}
