//
//  OfficialArtwork.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

struct OfficialArtwork: Codable, Hashable {

    let frontDefault: String?
    let frontShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}
