//
//  FlavorTextEntry.swift
//  Dexperience
//
//  Created by Byron on 4/13/25.
//

struct FlavorTextEntry: Codable {

    let flavorText: String?
    let language: Language?
    let version: GameVersion?

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case version
    }
}
