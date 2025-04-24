//
//  PokemonDetailViewController.swift
//  Dexperience
//
//  Created by Byron on 4/12/25.
//

import UIKit

final class PokemonDetailViewController<R: PokemonsRouter>: UIViewController, UICollectionViewDelegate,  UIScrollViewDelegate, HeaderDelegate {

    enum Section: Int, CaseIterable, Hashable {
        case stats
        case weaknesses
        case abilities
        case breeding
        case capture
        case sprites
        case evolutions
        case moves

        var title: String? {
            switch self {
            case .weaknesses:
                return "Weaknesses"
            case .abilities:
                return "Abilities"
            case .breeding:
                return "Breeding"
            case .capture:
                return "Capture"
            case .sprites:
                return "Sprites"
            default:
                return nil
            }
        }

        var shouldHaveHeader: Bool {
            return title != nil
        }
    }

    enum Item: Hashable {
        case stat(StatDisplay)
        case weakness([TypeElement])
        case ability(AbilityEntry)
        case breeding(BreedingInfo)
        case capture(CaptureInfo)
        case sprite(Sprites)
        case evolution(Evolution)
        case move(LearnableMove)
    }

    // MARK: - Properties

    private let viewModel: PokemonDetailViewModel<R>

    private let headerView = PokemonDetailHeaderView()

    private var headerViewTopConstraint: NSLayoutConstraint?
    private var containerViewTopConstraint: NSLayoutConstraint?

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private var backgroundGradientLayer: CAGradientLayer?

    private lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()

        label.font = .boldSystemFont(ofSize: 20)
        label.alpha = 0
        label.textColor = .white

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()

        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 48

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)

        button.setImage(UIImage(resource: .closeIcon), for: .normal)
        button.tintColor = .white

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            if let section = self.dataSource.snapshot().sectionIdentifiers[safe: sectionIndex] {
                if section.shouldHaveHeader {
                    config.headerMode = .supplementary
                }

                switch section {
                case .moves, .evolutions, .abilities:
                    config.showsSeparators = true
                default:
                    config.showsSeparators = false
                }
            }

            config.backgroundColor = .clear

            return .list(using: config, layoutEnvironment: layoutEnvironment)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self

        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    private let moveCellRegistration = UICollectionView.CellRegistration<PokemonMoveCellView, LearnableMove> { cell, indexPath, move in
        let viewModel = PokemonMoveCellViewModel(pokemonMove: move)

        cell.configure(with: viewModel)
    }

    private let evolutionCellRegistration = UICollectionView.CellRegistration<EvolutionCell, Evolution> { cell, indexPath, evolution in
        cell.configure(with: evolution)
    }

    private let statBarCellRegistration = UICollectionView.CellRegistration<StatBarCell, StatDisplay> { cell, _, stat in
        cell.configure(with: stat)
    }

    private let weaknessesCellRegistration = UICollectionView.CellRegistration<WeaknessesCell, [TypeElement]> { cell, _, types in
        cell.configure(types: types)
    }

    private let abilityCellRegistration = UICollectionView.CellRegistration<AbilityCell, AbilityEntry> { cell, _, entry in
        let viewModel = AbilityCellViewModel(entry: entry)

        cell.configure(with: viewModel)
    }

    private let breedingCellRegistration = UICollectionView.CellRegistration<BreedingCell, BreedingInfo> { cell, _, breeding in
        cell.configure(with: breeding)
    }

    private let captureCellRegistration = UICollectionView.CellRegistration<CaptureCell, CaptureInfo> { cell, _, capture in
        cell.configure(with: capture)
    }

    private let spritesCellRegistration = UICollectionView.CellRegistration<SpritesCell, Sprites> { cell, _, sprites in
        cell.configure(sprites: sprites)
    }

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .move(let move):
                return collectionView.dequeueConfiguredReusableCell(using: self.moveCellRegistration, for: indexPath, item: move)
            case .evolution(let evolution):
                return collectionView.dequeueConfiguredReusableCell(using: self.evolutionCellRegistration, for: indexPath, item: evolution)
            case .stat(let statDisplay):
                return collectionView.dequeueConfiguredReusableCell(using: self.statBarCellRegistration, for: indexPath, item: statDisplay)
            case .weakness(let types):
                return collectionView.dequeueConfiguredReusableCell(using: self.weaknessesCellRegistration, for: indexPath, item: types)
            case .ability(let entry):
                return collectionView.dequeueConfiguredReusableCell(using: self.abilityCellRegistration, for: indexPath, item: entry)
            case .breeding(let breeding):
                return collectionView.dequeueConfiguredReusableCell(using: self.breedingCellRegistration, for: indexPath, item: breeding)
            case .capture(let capture):
                return collectionView.dequeueConfiguredReusableCell(using: self.captureCellRegistration, for: indexPath, item: capture)
            case .sprite(let sprites):
                return collectionView.dequeueConfiguredReusableCell(using: self.spritesCellRegistration, for: indexPath, item: sprites)
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let section = dataSource.snapshot().sectionIdentifiers[safe: indexPath.section],
                  section.shouldHaveHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                    for: indexPath
                  ) as? SectionHeaderView else { return nil }

            header.configure(with: section.title)

            return header
        }

        return dataSource
    }()

    // MARK: - Initializers

    init(viewModel: PokemonDetailViewModel<R>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupNavigation()
        fetchInitData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer?.frame = view.bounds
    }

    // MARK: - ScrollView

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translationY = scrollView.panGestureRecognizer.translation(in: scrollView).y

        if processHeaderToggle(translationY: translationY) {
            scrollView.panGestureRecognizer.setTranslation(.zero, in: scrollView)
        }
    }

    func didSelectTab(at tab: Tab) {
        viewModel.currentTab = tab
        applySnapshot()
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .changed else { return }

        let translationY = gesture.translation(in: view).y

        if processHeaderToggle(translationY: translationY) {
            gesture.setTranslation(.zero, in: view)
        }
    }
}

// MARK: - Setup

private extension PokemonDetailViewController {

    func setupUI() {
        view.backgroundColor = .systemBackground
    }

    func setupNavigation() {
        view.addSubview(navigationTitleLabel)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            navigationTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            navigationTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        backButton.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
    }

    func setupCollectionView() {
        headerView.addGestureRecognizer(
            UIPanGestureRecognizer(
                target: self,
                action: #selector(handlePanGesture)
            )
        )

        headerView.delegate = self

        view.addSubview(containerView)
        containerView.addSubview(collectionView)
        view.addSubview(headerView)

        headerView.translatesAutoresizingMaskIntoConstraints = false

        headerViewTopConstraint = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: viewModel.headerTopConstraintConstant)
        containerViewTopConstraint = containerView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: viewModel.containerTopConstraintConstant)

        NSLayoutConstraint.activate([
            containerViewTopConstraint!,
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            headerViewTopConstraint!,
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }

    func applySnapshot() {
        var snapshot = Snapshot()

        switch viewModel.currentTab {
        case .moves:
            let moveItems = viewModel.pokemonMoves.map { Item.move($0) }

            snapshot.appendSections([.moves])
            snapshot.appendItems(moveItems, toSection: .moves)
        case .evolutions:
            let evolutionItems = viewModel.evolutions.map { Item.evolution($0) }

            snapshot.appendSections([.evolutions])
            snapshot.appendItems(evolutionItems, toSection: .evolutions)
        default:
            let statItems = viewModel.statDisplays.map { Item.stat($0) }

            snapshot.appendSections([.stats])
            snapshot.appendItems(statItems, toSection: .stats)

            if let types = viewModel.pokemon?.types {
                snapshot.appendSections([.weaknesses])
                snapshot.appendItems([Item.weakness(types)], toSection: .weaknesses)
            }

            if let pokemonAbilities = viewModel.pokemon?.abilities, !pokemonAbilities.isEmpty {
                let abilities = pokemonAbilities.compactMap { Item.ability($0) }

                snapshot.appendSections([.abilities])
                snapshot.appendItems(abilities, toSection: .abilities)
            }

            if let breeding = viewModel.breedingInfo {
                snapshot.appendSections([.breeding])
                snapshot.appendItems([Item.breeding(breeding)], toSection: .breeding)
            }

            if let capture = viewModel.captureInfo {
                snapshot.appendSections([.capture])
                snapshot.appendItems([Item.capture(capture)], toSection: .capture)
            }

            if let sprites = viewModel.pokemon?.sprites {
                snapshot.appendSections([.sprites])
                snapshot.appendItems([Item.sprite(sprites)], toSection: .sprites)
            }
        }

        dataSource.apply(snapshot)
    }

    func fetchInitData() {
        Task {
            do {
                try await withLoader { [weak self] in
                    guard let self else { return }

                    try await viewModel.fetchDetails()

                    if let pokemon = viewModel.pokemon {
                        navigationTitleLabel.text = pokemon.name?.formatted
                        headerView.configure(pokemon)
                    }

                    if let moveType = viewModel.pokemonType {
                        view.tintColor = moveType.color
                        backgroundGradientLayer = GradientProvider.softGradient(baseColor: moveType.color)

                        guard let backgroundGradientLayer else { return }

                        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
                    }

                    try await viewModel.fetchSpecie()

                    headerView.configureFlavorText(viewModel.flavorText)

                    applySnapshot()
                }
            } catch {
                presentAlert(type: .error, message: error.localizedDescription)
            }
        }
    }

    func processHeaderToggle(translationY: CGFloat) -> Bool {
        let deltaThreshold: CGFloat = 10

        if translationY < -deltaThreshold && !viewModel.isHeaderHidden {
            toggleHeader(hidden: true)

            return true
        } else if translationY > deltaThreshold && viewModel.isHeaderHidden {
            toggleHeader(hidden: false)

            return true
        }

        return false
    }

    func toggleHeader(hidden: Bool) {
        viewModel.isHeaderHidden = hidden

        let headerH = headerView.totalHeight
        let newHeaderTop = hidden ? -headerH : viewModel.headerTopConstraintConstant
        let newContainerTop = hidden ? (headerH + 35) : viewModel.containerTopConstraintConstant

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            guard let self else { return }

            headerViewTopConstraint?.constant = newHeaderTop
            containerViewTopConstraint?.constant = newContainerTop

            headerView.setAlpha(hidden ? 0 : 1)
            navigationTitleLabel.alpha = hidden ? 1 : 0

            view.layoutIfNeeded()
        }
    }
}
