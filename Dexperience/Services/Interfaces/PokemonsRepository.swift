//
//  PokemonsRepository.swift
//  Dexperience
//
//  Created by Byron on 4/6/25.
//

import Foundation

protocol PokemonsRepository {

    func fetchPokemonList(from url: URL?) async throws -> PokemonListResponse
    func fetchPokemon(url: URL) async throws -> Pokemon
    func pokemonType(url: URL) async throws -> TypeResponse
    func fetchSpecie(url: URL) async throws -> Specie
    func fetchEvolutionChain(url: URL) async throws -> EvolutionChainResponse
    func fetchPokemon(from name: String) async throws -> Pokemon
    func fetchAbility(url: URL) async throws -> Ability
}
