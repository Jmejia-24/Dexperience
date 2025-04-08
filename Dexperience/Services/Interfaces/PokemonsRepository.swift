//
//  PokemonsRepository.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import Foundation

protocol PokemonsRepository {

    func fetchPokemonList(offset: Int) async throws -> PokemonListResponse
    func fetchPokemon(url: URL) async throws -> Pokemon
}
