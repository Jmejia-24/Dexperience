//
//  MoveStatsCell.swift
//  Dexperience
//
//  Created by Byron on 4/12/25.
//

import UIKit

final class MoveStatsCell: TripleColumnBaseCell {

    private lazy var powerStack = makeStatStack()
    private lazy var accuracyStack = makeStatStack()
    private lazy var ppStack = makeStatStack()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with move: Move) {
        setStack(powerStack, title: "Base Power", value: move.power?.description ?? "—")
        setStack(accuracyStack, title: "Accuracy", value: move.accuracy.map { "\($0)%" } ?? "—")
        setStack(ppStack, title: "PP", value: move.pp?.description ?? "—")
    }
}

private extension MoveStatsCell {

    func setupViews() {
        configureColumns([powerStack, accuracyStack, ppStack])
    }

    func makeStatStack() -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .tintColor
        titleLabel.textAlignment = .center

        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 19, weight: .light)
        valueLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        
        return stack
    }

    func setStack(_ stack: UIStackView, title: String, value: String) {
        guard let titleLabel = stack.arrangedSubviews.first as? UILabel,
              let valueLabel = stack.arrangedSubviews.last as? UILabel else { return }

        titleLabel.text = title
        valueLabel.text = value
    }
}
