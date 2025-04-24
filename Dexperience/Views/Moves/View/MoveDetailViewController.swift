//
//  MoveDetailViewController.swift
//  Dexperience
//
//  Created by Byron on 4/11/25.
//

import UIKit

final class MoveDetailViewController<R: MovesRouter>: UIViewController, UICollectionViewDelegate,  UIScrollViewDelegate {

    private enum Section: CaseIterable {
        case infoList
        case stats
    }

    private enum MoveItem: Hashable {
        case info(String)
        case stat(Move)
    }

    // MARK: - Properties

    private let viewModel: MoveDetailViewModel<R>

    private let headerView = MoveDetailHeaderView()

    private var headerViewTopConstraint: NSLayoutConstraint?
    private var containerViewTopConstraint: NSLayoutConstraint?

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MoveItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MoveItem>

    private var backgroundGradientLayer: CAGradientLayer? = GradientProvider.softGradient(baseColor: .tintColor)

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

            config.showsSeparators = false
            config.backgroundColor = .clear

            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.layer.cornerRadius = 48
        collectionView.delegate = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    private let infoCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, text in
        var config = UIListContentConfiguration.valueCell()

        config.text = text.cleaned
        config.textProperties.numberOfLines = 0
        config.textProperties.alignment = .center
        config.textProperties.font = .systemFont(ofSize: 16, weight: .light)

        cell.contentConfiguration = config

        var backgroundConfig = UIBackgroundConfiguration.listCell()
        backgroundConfig.backgroundColor = .clear

        cell.backgroundConfiguration = backgroundConfig
    }

    private let statCellRegistration = UICollectionView.CellRegistration<MoveStatsCell, MoveItem> { cell, _, item in
        guard case let .stat(move) = item else { return }

        cell.configure(with: move)
    }

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .info(let text):
                return collectionView.dequeueConfiguredReusableCell(using: self.infoCellRegistration, for: indexPath, item: text)
            case .stat:
                return collectionView.dequeueConfiguredReusableCell(using: self.statCellRegistration, for: indexPath, item: item)
            }
        }

        return dataSource
    }()

    // MARK: - Initializers

    init(viewModel: MoveDetailViewModel<R>) {
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

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .changed else { return }

        let translationY = gesture.translation(in: view).y

        if processHeaderToggle(translationY: translationY) {
            gesture.setTranslation(.zero, in: view)
        }
    }
}

// MARK: - Setup

private extension MoveDetailViewController {

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
        view.addSubview(containerView)
        containerView.addSubview(collectionView)
        view.addSubview(headerView)

        headerView.translatesAutoresizingMaskIntoConstraints = false

        headerViewTopConstraint = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        containerViewTopConstraint = containerView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: viewModel.containerTopConstraintConstant)

        NSLayoutConstraint.activate([
            containerViewTopConstraint!,
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            headerViewTopConstraint!,
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func applySnapshot() {
        var snapshot = Snapshot()

        snapshot.appendSections(Section.allCases)

        let infoItems = viewModel.infoList.map { MoveItem.info($0) }

        snapshot.appendItems(infoItems, toSection: .infoList)

        if let move = viewModel.move {
            snapshot.appendItems([MoveItem.stat(move)], toSection: .stats)
        }

        dataSource.apply(snapshot)
    }

    func fetchInitData() {
        Task {
            do {
                try await withLoader { [weak self] in
                    guard let self else { return }

                    try await viewModel.fetchDetails()

                    if let move = viewModel.move {
                        navigationTitleLabel.text = move.name?.formatted
                        headerView.configure(move)
                        applySnapshot()
                    }

                    if let moveType = viewModel.moveType {
                        view.tintColor = moveType.color
                        backgroundGradientLayer = GradientProvider.softGradient(baseColor: moveType.color)

                        guard let backgroundGradientLayer else { return }

                        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
                    }
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

        let headerH = headerView.totalheight
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
