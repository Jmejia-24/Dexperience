//
//  PokemonPreview.swift
//  Dexperience
//
//  Created by Byron on 4/9/25.
//

import UIKit

final class PokemonPreview: UIViewController {

    private let viewModel: PokemonPreviewViewModel
    private let cardView = PokemonCardView()

    private lazy var separatorView: UIView = {
        let view = UIView()

        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var typesInfoStack: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cardView, separatorView, typesInfoStack])

        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    init(viewModel: PokemonPreviewViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no está implementado")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()

        let fittingSize = contentStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let padding: CGFloat = 16
        let width = max(fittingSize.width + padding, 350)
        let height = max(fittingSize.height + padding, 350)

        preferredContentSize = CGSize(width: width, height: height)
    }
}

private extension PokemonPreview {

    func loadData() {
        Task {
            do {
                try await viewModel.loadOffensiveDamageRelations()
                await MainActor.run {
                    setupOffensiveStack()
                }

                cardView.configure(with: viewModel.pokemon)
            } catch {
                print("Error al cargar relaciones ofensivas: \(error)")
            }
        }
    }

    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true

        view.addSubview(contentStack)

        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            contentStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    func setupOffensiveStack() {
        let sortedOffensiveData = viewModel.offensiveData.sorted(by: { $0.key.rawValue < $1.key.rawValue })

        for rowStart in stride(from: 0, to: sortedOffensiveData.count, by: viewModel.columns) {
            let rowStack = UIStackView()

            rowStack.axis = .horizontal
            rowStack.alignment = .center
            rowStack.distribution = .fillEqually
            rowStack.spacing = 8

            let rowEnd = min(rowStart + viewModel.columns, sortedOffensiveData.count)
            let rowItems = sortedOffensiveData[rowStart..<rowEnd]

            for (typeName, multiplier) in rowItems {
                let cellView = makeCell(for: typeName, multiplier: multiplier)

                rowStack.addArrangedSubview(cellView)
            }

            typesInfoStack.addArrangedSubview(rowStack)
        }
    }

    func makeCell(for type: PokemonType, multiplier: Double) -> UIView {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.image = type.image
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.heightAnchor.constraint(equalToConstant: 35)
        ])

        let label = UILabel()

        label.text = viewModel.formatMultiplier(multiplier)
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.textAlignment = .center

        let container = UIStackView(arrangedSubviews: [imageView, label])

        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 4

        return container
    }
}
