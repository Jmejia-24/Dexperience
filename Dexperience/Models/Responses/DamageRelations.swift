//
//  DamageRelations.swift
//  Dexperience
//
//  Created by Byron on 4/8/25.
//

struct DamageRelations: Codable {

    let doubleDamageFrom: [PokemonSummary]?
    let doubleDamageTo: [PokemonSummary]?
    let halfDamageFrom: [PokemonSummary]?
    let halfDamageTo: [PokemonSummary]?
    let noDamageFrom: [PokemonSummary]?
    let noDamageTo: [PokemonSummary]?

    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
        case doubleDamageTo = "double_damage_to"
        case halfDamageFrom = "half_damage_from"
        case halfDamageTo = "half_damage_to"
        case noDamageFrom = "no_damage_from"
        case noDamageTo = "no_damage_to"
    }
}
