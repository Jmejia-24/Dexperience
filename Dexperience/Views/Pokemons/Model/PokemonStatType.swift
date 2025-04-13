//
//  PokemonStatType.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

enum PokemonStatType: String, CaseIterable, Codable {

    case hp = "hp"
    case attack = "attack"
    case defense = "defense"
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed = "speed"

    var shortName: String {
        switch self {
        case .hp: 
            return "HP"
        case .attack: 
            return "ATK"
        case .defense:
            return "DEF"
        case .specialAttack:
            return "SATK"
        case .specialDefense:
            return "SDEF"
        case .speed:
            return "SPD"
        }
    }
}
