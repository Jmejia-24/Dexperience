//
//  EvolutionDetail.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

struct EvolutionDetail: Codable {

    let minLevel: Int?

    enum CodingKeys: String, CodingKey {
        case minLevel = "min_level"
    }
}
