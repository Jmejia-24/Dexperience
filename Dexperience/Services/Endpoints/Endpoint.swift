//
//  Endpoint.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import Foundation

enum Endpoint: String, CaseIterable, Hashable {

    case pokemon
    case move
    case item
    case ability
    case evolutionChain = "evolution-chain"
    case pokemonSpecies = "pokemon-species"
    case type
}
