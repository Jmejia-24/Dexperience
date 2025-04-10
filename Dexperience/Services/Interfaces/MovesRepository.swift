//
//  MovesRepository.swift
//  Dexperience
//
//  Created by Byron on 4/9/25.
//

import Foundation

protocol MovesRepository {

    func fetchMoveList(from url: URL?) async throws -> PokemonListResponse
    func fetchMove(url: URL) async throws -> Move
}
