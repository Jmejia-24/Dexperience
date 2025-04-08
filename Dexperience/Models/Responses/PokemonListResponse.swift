//
//  PokemonListResponse.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

struct PokemonListResponse: Codable {

    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonSummary]

    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }
}
