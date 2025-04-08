//
//  PokemonsViewController.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

final class PokemonsViewController<R: PokemonsRouter>: UICollectionViewController, UISearchResultsUpdating, UICollectionViewDataSourcePrefetching {

    private enum Section: CaseIterable {
        case main
    }

    // MARK: - Properties

    private let viewModel: PokemonsViewModel<R>

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PokemonSummary>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PokemonSummary>

    private let registerPokemonCell = UICollectionView.CellRegistration<PokemonCellView, PokemonSummary> { cell, indexPath, pokemon in
        let viewModel = PokemonCellViewModel(stringUrl: pokemon.url)

        cell.configure(with: viewModel)
    }

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            let configType = self.registerPokemonCell

            return collectionView.dequeueConfiguredReusableCell(using: configType, for: indexPath, item: item)
        }

        return dataSource
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .label

        return searchController
    }()

    // MARK: - Initializers

    init(viewModel: PokemonsViewModel<R>) {
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
        let filteredResults = viewModel.searchPokemon(with: searchController.searchBar.text)

        applySnapshot(pokemons: filteredResults)
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let count = viewModel.pokemonList.count

        if indexPaths.contains(where: { $0.item >= count - 10 }) {
            Task {
                do {
                    try await viewModel.fetchMorePokemon()

                    applySnapshot(pokemons: viewModel.pokemonList)
                } catch {
                    print("Error al cargar más datos: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Private methods

private extension PokemonsViewController {

    static func makeListLayout() -> UICollectionViewCompositionalLayout {
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)

        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }

    func setupUI() {
        title = "Pokemon"

        collectionView.prefetchDataSource = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func fetchInitData() {
        Task {
            do {
                try await viewModel.getPokemonList()

                applySnapshot(pokemons: viewModel.pokemonList)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func applySnapshot(pokemons: [PokemonSummary]) {
        var snapshot = Snapshot()

        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(pokemons, toSection: $0) }

        dataSource.apply(snapshot)
    }
}
