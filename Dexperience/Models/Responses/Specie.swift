//
//  Specie.swift
//  Dexperience
//
//  Created by Byron on 4/13/25.
//

struct Specie: Codable {

    let flavorTextEntries: [FlavorTextEntry]?
    let evolutionChain: PokemonSummary?
    let varieties: [PokemonVariety]?
    let eggGroups: [PokemonSummary]?
    let genderRate: Int?
    let hatchCounter: Int?
    let captureRate: Int?
    let habitat: PokemonSummary?
    let generation: PokemonSummary?

    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
        case evolutionChain = "evolution_chain"
        case varieties
        case eggGroups = "egg_groups"
        case genderRate = "gender_rate"
        case hatchCounter = "hatch_counter"
        case captureRate = "capture_rate"
        case habitat
        case generation
    }
}
