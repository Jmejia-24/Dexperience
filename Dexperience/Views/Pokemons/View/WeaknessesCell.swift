//
//  WeaknessesCell.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

import UIKit

final class WeaknessesCell: UICollectionViewCell {

    private var damageMatrixView: DamageMatrixView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        damageMatrixView?.removeFromSuperview()
        damageMatrixView = nil
    }

    func configure(types: [TypeElement]) {

        let viewModel = DamageMatrixViewModel(types: types, mode: .defensive)
        let matrixView = DamageMatrixView(viewModel: viewModel)

        matrixView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(matrixView)

        let heightConstraint = matrixView.heightAnchor.constraint(equalToConstant: 300)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            heightConstraint,
            matrixView.topAnchor.constraint(equalTo: contentView.topAnchor),
            matrixView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            matrixView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            matrixView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32)
        ])

        damageMatrixView = matrixView
    }
}
