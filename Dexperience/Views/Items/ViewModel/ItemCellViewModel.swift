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

    private(set) var item: Item?

    var onUpdate: (() -> Void)?

    // MARK: - Initializer

    init(stringUrl: String?, api: ItemsRepository = APIManager()) {
        self.itemURL = stringUrl
        self.api = api

        Task { @MainActor in
            await fetchDetails()
        }
    }
}

private extension ItemCellViewModel {

    // MARK: - Data Fetching

    func fetchDetails() async {
        guard let itemURL,
              let url = URL(string: itemURL) else { return }

        do {
            item = try await api.fetchItem(url: url)

            onUpdate?()
        } catch {
            onUpdate?()
        }
    }
}
