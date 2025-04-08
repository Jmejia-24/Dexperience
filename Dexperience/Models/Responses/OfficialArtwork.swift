//
//  OfficialArtwork.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

struct OfficialArtwork: Codable, Hashable {

    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
