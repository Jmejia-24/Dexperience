//
//  APIManager+MovesRepository.swift
//  Dexperience
//
//  Created by Byron on 4/9/25.
//

import Foundation

extension APIManager: MovesRepository {

    func fetchMoveList(from url: URL?) async throws -> PokemonListResponse {
        var request: Request

        if let url {
            request = Request(with: url)
        } else {
            request = Request(
                endpoint: .move,
                queryParameters: [
                    .init(name: "limit", value: "50")
                ],
            )
        }

        return try await execute(request)
    }

    func fetchMove(url: URL) async throws -> Move {
        let request = Request(with: url)

        return try await execute(request)
    }
}
