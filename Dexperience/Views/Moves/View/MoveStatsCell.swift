//
//  MoveStatsCell.swift
//  Dexperience
//
//  Created by Byron on 4/12/25.
//

import UIKit

final class MoveStatsCell: UICollectionViewCell {

    private lazy var powerStack = makeStatStack()
    private lazy var accuracyStack = makeStatStack()
    private lazy var ppStack = makeStatStack()

    private lazy var separator1 = makeSeparator()
    private lazy var separator2 = makeSeparator()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            powerStack, separator1,
            accuracyStack, separator2,
            ppStack
        ])

        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill

        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(with move: Move) {
        setStack(powerStack, title: "Base Power", value: move.power?.description ?? "—")
        setStack(accuracyStack, title: "Accuracy", value: move.accuracy.map { "\($0)%" } ?? "—")
        setStack(ppStack, title: "PP", value: move.pp?.description ?? "—")
    }
}

private extension MoveStatsCell {

    func makeStatStack() -> UIStackView {
        let titleLabel = UILabel()

        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .tintColor
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear

        let valueLabel = UILabel()

        valueLabel.font = .systemFont(ofSize: 19, weight: .light)
        valueLabel.textAlignment = .center
        valueLabel.backgroundColor = .clear

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])

        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalToConstant: 102)
        ])

        return stack
    }

    func makeSeparator() -> UIView {
        let view = UIView()

        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 1)
        ])

        return view
    }

    func setStack(_ stack: UIStackView, title: String, value: String) {
        guard let titleLabel = stack.arrangedSubviews.first as? UILabel,
              let valueLabel = stack.arrangedSubviews.last as? UILabel else { return }

        titleLabel.text = title
        valueLabel.text = value
    }
}
