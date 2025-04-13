//
//  EvolutionChain.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

struct EvolutionChain: Codable {

    let species: PokemonSummary?
    let evolvesTo: [EvolutionChain]?
    let evolutionDetails: [EvolutionDetail]?

    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
        case evolutionDetails = "evolution_details"
    }
}
