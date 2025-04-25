//
//  APIManager+ItemsRepository.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//

import Foundation

extension APIManager: ItemsRepository {

    func fetchItemList(from url: URL?) async throws -> PokemonListResponse {
        var request: Request

        if let url {
            request = Request(with: url)
        } else {
            request = Request(
                endpoint: .item,
                queryParameters: [
                    .init(name: "limit", value: "50")
                ],
            )
        }

        return try await execute(request)
    }

    func fetchItem(from path: String) async throws -> Item {
        let request = Request(
            endpoint: .item,
            pathComponents: [path]
        )

        return try await execute(request)
    }
}
