//
//  StatDisplay.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

struct StatDisplay: Hashable {

    let value: Int
    let type: PokemonStatType

    var shortName: String { type.shortName }
}
