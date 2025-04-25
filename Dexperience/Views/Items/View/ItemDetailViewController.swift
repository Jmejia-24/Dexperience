//
//  ItemDetailViewController.swift
//  Dexperience
//
//  Created by Byron on 4/10/25.
//

import UIKit

final class ItemDetailViewController<R: ItemsRouter>: UIViewController, UICollectionViewDelegate,  UIScrollViewDelegate {

    private enum Section: CaseIterable {
        case main
    }

    // MARK: - Properties

    private let viewModel: ItemDetailViewModel<R>

    private let headerView = ItemDetailHeaderView()

    private var headerViewTopConstraint: NSLayoutConstraint?
    private var containerViewTopConstraint: NSLayoutConstraint?

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>

    private lazy var backgroundGradientLayer = GradientProvider.make(style: .custom([
        #colorLiteral(red: 0.4404543042, green: 0.8308128119, blue: 0.7981370091, alpha: 1),
        #colorLiteral(red: 0.4650884867, green: 0.8307561278, blue: 0.6747831106, alpha: 1),
        #colorLiteral(red: 0.485091567, green: 0.8347114921, blue: 0.5588895082, alpha: 1)
    ]))

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

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
            let configType = self.infoCellRegistration

            return collectionView.dequeueConfiguredReusableCell(using: configType, for: indexPath, item: item)
        }

        return dataSource
    }()

    // MARK: - Initializers

    init(viewModel: ItemDetailViewModel<R>) {
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
        backgroundGradientLayer.frame = view.bounds
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

private extension ItemDetailViewController {

    func setupUI() {
        view.backgroundColor = .systemBackground
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
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

        view.addSubview(containerView)
        containerView.addSubview(collectionView)
        view.addSubview(headerView)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

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
        Section.allCases.forEach { snapshot.appendItems(viewModel.infoList, toSection: $0) }

        dataSource.apply(snapshot)
    }

    func fetchInitData() {
        Task {
            do {
                try await withLoader { [weak self] in
                    guard let self else { return }

                    try await viewModel.fetchDetails()

                    if let item = viewModel.item {
                        navigationTitleLabel.text = item.name?.formatted
                        headerView.configure(item)
                        applySnapshot()
                    }
                }
            } catch {
                presentAlert(type: .error, message: error.localizedDescription, onPrimary: { [weak self] in
                    self?.dismiss(animated: true)
                })
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
