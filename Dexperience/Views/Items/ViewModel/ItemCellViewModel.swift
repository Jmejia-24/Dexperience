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
    private let itemURL: String?

    // MARK: - Initializer

    init(stringUrl: String?, api: ItemsRepository = APIManager()) {
        self.itemURL = stringUrl
        self.api = api
    }

    func fetchDetails() async throws -> Item? {
        guard let itemPath = itemURL?.lastPathComponent else { return nil }

        return try await api.fetchItem(from: itemPath)
    }
}
