//
//  GenericListViewController.swift
//  Dexperience
//
//  Created by Byron on 4/18/25.
//

import UIKit

class GenericListViewController<Cell: UICollectionViewCell, Handler: GenericListHandler>: UICollectionViewController, UISearchResultsUpdating, UICollectionViewDataSourcePrefetching where Handler.Model: Hashable {

    enum Section: CaseIterable {
        case main
    }

    typealias Model = Handler.Model
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Model>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Model>

    private let handler: Handler
    private let cellRegistration: UICollectionView.CellRegistration<Cell, Model>

    private lazy var dataSource: DataSource = {
        DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }

            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)

        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search"

        return controller
    }()

    init(handler: Handler, cellRegistration: UICollectionView.CellRegistration<Cell, Model>) {
        self.handler = handler
        self.cellRegistration = cellRegistration
        super.init(collectionViewLayout: Self.makeListLayout())
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = handler.title
        collectionView.prefetchDataSource = self

        Task {
            await fetchInitial()
        }
    }

    private func setupUI() {
        navigationItem.title = handler.title
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    static func makeListLayout() -> UICollectionViewCompositionalLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)

        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }

    func updateSearchResults(for searchController: UISearchController) {
        Task {
            let filtered = await handler.search(query: searchController.searchBar.text)

            applySnapshot(filtered)
        }
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        Task {
            do {
                let more = try await handler.prefetch(at: indexPaths)

                applySnapshot(more)
            } catch {
                print("❌ Prefetch error: \(error)")
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

        handler.didSelect(item: item)
    }

    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first,
              let item = dataSource.itemIdentifier(for: indexPath) else { return nil }

        return handler.contextMenu(for: indexPath, item: item)
    }
}

// MARK: - Private methods

private extension GenericListViewController {

    func applySnapshot(_ items: [Model]) {
        var snapshot = Snapshot()

        snapshot.appendSections(Section.allCases)

        Section.allCases.forEach {
            snapshot.appendItems(items, toSection: $0)
        }

        dataSource.apply(snapshot)
    }

    func fetchInitial() async {
        do {
            let result = try await handler.fetchInitialData()

            applySnapshot(result)
        } catch {
            print("❌ Error inicial: \(error)")
        }
    }
}
