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

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
    }
}

extension Move {

    var formattedName: String {
        name?
            .replacingOccurrences(of: "-", with: " ")
            .capitalized ?? ""
    }
}
