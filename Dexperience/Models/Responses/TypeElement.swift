//
//  TypeElement.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

nonisolated
struct TypeElement: Codable, Hashable, Sendable {
    
    let slot: Int?
    let type: PokemonSummary?

    enum CodingKeys: String, CodingKey {
        case slot
        case type
    }
}
