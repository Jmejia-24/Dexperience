//
//  MovesViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/9/25.
//

import Foundation

final class MovesViewModel<R: MovesRouter> {

    // MARK: - Properties

    private let router: R
    private let api: MovesRepository
    private var moveListResponse: PokemonListResponse?
    private var isFetchingMore = false

    var moveList: [PokemonSummary] = []

    // MARK: - Initializers

    init(router: R, api: MovesRepository = APIManager()) {
        self.router = router
        self.api = api
    }

    @MainActor
    func getMoveList() async throws {
        let response = try await api.fetchMoveList(from: nil)

        moveListResponse = response
        moveList = response.results
    }

    @MainActor
    func fetchMoreMoves() async throws {
        guard !isFetchingMore,
              let nextUrlString = moveListResponse?.next,
              let nextUrl = URL(string: nextUrlString) else { return }

        isFetchingMore = true

        let response = try await api.fetchMoveList(from: nextUrl)
        moveListResponse = response

        moveList.append(contentsOf: response.results)

        isFetchingMore = false
    }

    func searchMove(with query: String?) -> [PokemonSummary] {
        guard let query = query?.lowercased(), !query.isEmpty else {
            return moveList
        }

        return moveList.filter { move in
            move.name?.lowercased().contains(query) ?? false
        }
    }
}

// MARK: - Navigation

extension MovesViewModel {

}
