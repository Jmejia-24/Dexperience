//
//  ItemDetailViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//

import Foundation

final class ItemDetailViewModel<R: ItemsRouter> {

    // MARK: - Properties

    private let router: R
    private let api: ItemsRepository
    private let itemURL: String?

    let containerTopConstraintConstant: CGFloat = 67
    var item: Item?
    var infoList = [String]()

    // MARK: - Initializers

    init(router: R, api: ItemsRepository = APIManager(), stringUrl: String?) {
        self.router = router
        self.api = api
        self.itemURL = stringUrl
    }

    // MARK: - Data Fetching

    @MainActor
    func fetchDetails() async throws {
        guard let itemURL,
              let url = URL(string: itemURL) else { return }

        let itemResponse = try await api.fetchItem(url: url)

        item = itemResponse
        infoList = itemResponse.effectEntries?.compactMap { $0.effect } ?? []
    }
}
