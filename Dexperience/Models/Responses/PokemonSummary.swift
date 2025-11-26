//
//  PokemonSummary.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

nonisolated
struct PokemonSummary: Codable, Hashable, Sendable {

    let name: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
