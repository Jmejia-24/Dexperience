//
//  ItemCellViewModel.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//

import UIKit

final class ItemCellViewModel {

    // MARK: - Properties

    private let api: ItemsRepository
    private let itemPath: String?

    // MARK: - Initializer

    init(itemPath: String?, api: ItemsRepository = APIManager()) {
        self.itemPath = itemPath
        self.api = api
    }

    func fetchDetails() async throws -> Item? {
        guard let itemPath else { return nil }

        return try await api.fetchItem(from: itemPath)
    }
}
