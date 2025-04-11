//
//  ItemsViewController.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class ItemsViewController<R: ItemsRouter>: UICollectionViewController, UISearchResultsUpdating, UICollectionViewDataSourcePrefetching  {

    private enum Section: CaseIterable {
        case main
    }

    // MARK: - Properties

    private let viewModel: ItemsViewModel<R>

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PokemonSummary>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PokemonSummary>

    private let registerItemCell = UICollectionView.CellRegistration<ItemCellView, PokemonSummary> { cell, indexPath, pokemon in
        let viewModel = ItemCellViewModel(stringUrl: pokemon.url)

        cell.configure(with: viewModel)
    }

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            let configType = self.registerItemCell

            return collectionView.dequeueConfiguredReusableCell(using: configType, for: indexPath, item: item)
        }

        return dataSource
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"

        return searchController
    }()

    // MARK: - Initializers

    init(viewModel: ItemsViewModel<R>) {
        self.viewModel = viewModel

        super.init(collectionViewLayout: Self.makeListLayout())

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInitData()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }

        viewModel.showDetail(item)
    }

    func updateSearchResults(for searchController: UISearchController) {
        let filteredResults = viewModel.searchMove(with: searchController.searchBar.text)

        applySnapshot(items: filteredResults)
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let count = viewModel.itemList.count

        if indexPaths.contains(where: { $0.item >= count - 10 }) {
            Task {
                do {
                    try await viewModel.fetchMoreItems()

                    applySnapshot(items: viewModel.itemList)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Private methods

private extension ItemsViewController {

    static func makeListLayout() -> UICollectionViewCompositionalLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)

        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }

    func setupUI() {
        title = "Items"

        collectionView.prefetchDataSource = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func fetchInitData() {
        Task {
            do {
                try await viewModel.getItemList()

                applySnapshot(items: viewModel.itemList)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func applySnapshot(items: [PokemonSummary]) {
        var snapshot = Snapshot()

        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(items, toSection: $0) }

        dataSource.apply(snapshot)
    }
}
