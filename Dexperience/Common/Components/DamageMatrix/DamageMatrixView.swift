//
//  DamageMatrixView.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

import UIKit

final class DamageMatrixView: UIView {

    private let viewModel: DamageMatrixViewModel

    private lazy var typesInfoStack: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    init(viewModel: DamageMatrixViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        loadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return typesInfoStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

private extension DamageMatrixView {

    func setupView() {
        addSubview(typesInfoStack)

        NSLayoutConstraint.activate([
            typesInfoStack.topAnchor.constraint(equalTo: topAnchor),
            typesInfoStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            typesInfoStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            typesInfoStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func loadData() {
        Task {
            do {
                try await viewModel.loadDamageRelations()
                await MainActor.run { self.populateStack() }
            } catch {
                print("Error loading damage relations: \(error)")
            }
        }
    }

    func populateStack() {
        let sortedData = viewModel.data.sorted(by: { $0.key.rawValue < $1.key.rawValue })

        for start in stride(from: 0, to: sortedData.count, by: viewModel.columns) {
            let rowStack = UIStackView()

            rowStack.axis = .horizontal
            rowStack.alignment = .center
            rowStack.distribution = .fillEqually
            rowStack.spacing = 8

            let end = min(start + viewModel.columns, sortedData.count)
            let rowItems = sortedData[start..<end]

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

        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 40)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            heightConstraint,
            imageView.widthAnchor.constraint(equalToConstant: 40)
        ])

        let label = UILabel()

        label.text = viewModel.formatMultiplier(multiplier)
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        let container = UIStackView(arrangedSubviews: [imageView, label])

        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 4
        container.translatesAutoresizingMaskIntoConstraints = false

        return container
    }
}
