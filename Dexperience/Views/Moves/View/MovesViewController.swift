//
//  MovesViewController.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class MovesViewController<R: MovesRouter>: UICollectionViewController, UISearchResultsUpdating, UICollectionViewDataSourcePrefetching {

    private enum Section: CaseIterable {
        case main
    }

    // MARK: - Properties

    private let viewModel: MovesViewModel<R>

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PokemonSummary>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PokemonSummary>

    private let registerMoveCell = UICollectionView.CellRegistration<MoveCellView, PokemonSummary> { cell, indexPath, pokemon in
        let viewModel = MoveCellViewModel(stringUrl: pokemon.url)

        cell.configure(with: viewModel)
    }

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            let configType = self.registerMoveCell

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

    init(viewModel: MovesViewModel<R>) {
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
        guard let pokemon = dataSource.itemIdentifier(for: indexPath) else { return }

        print(pokemon)
    }

    func updateSearchResults(for searchController: UISearchController) {
        let filteredResults = viewModel.searchMove(with: searchController.searchBar.text)

        applySnapshot(moves: filteredResults)
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let count = viewModel.moveList.count

        if indexPaths.contains(where: { $0.item >= count - 10 }) {
            Task {
                do {
                    try await viewModel.fetchMoreMoves()

                    applySnapshot(moves: viewModel.moveList)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Private methods

private extension MovesViewController {

    static func makeListLayout() -> UICollectionViewCompositionalLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)

        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }

    func setupUI() {
        title = "Moves"

        collectionView.prefetchDataSource = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func fetchInitData() {
        Task {
            do {
                try await viewModel.getMoveList()

                applySnapshot(moves: viewModel.moveList)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func applySnapshot(moves: [PokemonSummary]) {
        var snapshot = Snapshot()

        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(moves, toSection: $0) }

        dataSource.apply(snapshot)
    }
}
