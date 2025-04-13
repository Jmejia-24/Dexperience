//
//  MoveElement.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

struct MoveElement: Codable, Hashable {

    let move: PokemonSummary?
    let versionGroupDetails: [VersionGroupDetail]?

    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}
