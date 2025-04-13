//
//  EvolutionChainResponse.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

struct EvolutionChainResponse: Codable {

    let chain: EvolutionChain?

    enum CodingKeys: String, CodingKey {
        case chain
    }
}
