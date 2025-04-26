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
    private let itemPath: String?

    let containerTopConstraintConstant: CGFloat = 67
    let headerTopConstraintConstant: CGFloat = 30

    var isHeaderHidden = false

    var item: Item?
    var infoList = [String]()

    var itemDeepLink: URL? {
        guard let itemPath else { return nil }

        return URL(string: "dexperience://tab/items/\(itemPath)")
    }

    // MARK: - Initializers

    init(router: R, api: ItemsRepository = APIManager(), itemPath: String?) {
        self.router = router
        self.api = api
        self.itemPath = itemPath
    }

    // MARK: - Data Fetching

    @MainActor
    func fetchDetails() async throws {
        guard let itemPath else { return }

        let itemResponse = try await api.fetchItem(from: itemPath)

        item = itemResponse
        infoList = itemResponse.effectEntries?.compactMap { $0.effect } ?? []
    }
}
