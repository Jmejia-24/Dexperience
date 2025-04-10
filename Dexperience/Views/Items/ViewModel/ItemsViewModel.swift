//
//  ItemsViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//

import Foundation

final class ItemsViewModel<R: ItemsRouter> {

    // MARK: - Properties

    private let router: R
    private let api: ItemsRepository
    private var itemListResponse: PokemonListResponse?
    private var isFetchingMore = false

    var itemList: [PokemonSummary] = []

    // MARK: - Initializers

    init(router: R, api: ItemsRepository = APIManager()) {
        self.router = router
        self.api = api
    }

    @MainActor
    func getItemList() async throws {
        let response = try await api.fetchItemList(from: nil)

        itemListResponse = response
        itemList = response.results
    }

    @MainActor
    func fetchMoreItems() async throws {
        guard !isFetchingMore,
              let nextUrlString = itemListResponse?.next,
              let nextUrl = URL(string: nextUrlString) else { return }

        isFetchingMore = true

        let response = try await api.fetchItemList(from: nextUrl)
        itemListResponse = response

        itemList.append(contentsOf: response.results)

        isFetchingMore = false
    }

    func searchMove(with query: String?) -> [PokemonSummary] {
        guard let query = query?.lowercased(), !query.isEmpty else {
            return itemList
        }

        return itemList.filter { item in
            item.name?.lowercased().contains(query) ?? false
        }
    }
}

// MARK: - Navigation

extension ItemsViewModel {

}
