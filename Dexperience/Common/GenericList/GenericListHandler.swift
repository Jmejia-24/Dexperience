//
//  GenericListHandler.swift
//  Dexperience
//
//  Created by Byron on 4/18/25.
//

import UIKit

protocol GenericListHandler<Model>: AnyObject {
    associatedtype Model: Hashable

    var title: String { get }

    func fetchInitialData() async throws -> [Model]
    func search(query: String?) async -> [Model]
    func prefetch(at indexPaths: [IndexPath]) async throws -> [Model]
    func didSelect(item: Model)
    func contextMenu(for indexPath: IndexPath, item: Model) -> UIContextMenuConfiguration?
}
