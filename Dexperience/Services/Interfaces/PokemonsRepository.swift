//
//  PokemonsRepository.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import Foundation

protocol PokemonsRepository {

    func fetchPokemonList(from url: URL?) async throws -> PokemonListResponse
    func pokemonType(from path: String) async throws -> TypeResponse
    func fetchSpecie(from path: String) async throws -> Specie
    func fetchEvolutionChain(from path: String) async throws -> EvolutionChainResponse
    func fetchPokemon(from path: String) async throws -> Pokemon
    func fetchAbility(from path: String) async throws -> Ability
}
