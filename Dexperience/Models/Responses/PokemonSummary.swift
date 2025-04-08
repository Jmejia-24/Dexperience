//
//  PokemonSummary.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

struct PokemonSummary: Codable, Hashable {

    let name: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
