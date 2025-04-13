//
//  VersionGroupDetail.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

struct VersionGroupDetail: Codable, Hashable {

    let levelLearnedAt: Int?
    let moveLearnMethod: PokemonSummary?
    let versionGroup: PokemonSummary?

    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}
