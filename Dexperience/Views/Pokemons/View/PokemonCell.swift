//
//  PokemonCell.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

import UIKit

final class PokemonCellView: UICollectionViewCell {

    private let cardView = PokemonCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with viewModel: PokemonCellViewModel) {
        cardView.configure(with: viewModel.pokemon)

        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.cardView.configure(with: viewModel.pokemon)
            }
        }
    }
}

private extension PokemonCellView {

    // MARK: - Setup

    func setupView() {
        contentView.backgroundColor = .secondarySystemBackground

        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
