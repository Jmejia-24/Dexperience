//
//  CaptureCell.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

import UIKit

final class CaptureCell: TripleColumnBaseCell {

    private lazy var habitatLabel = makeHeaderLabel(text: "Habitat")
    private lazy var habitatValueLabel = makeValueLabel()

    private lazy var generationLabel = makeHeaderLabel(text: "Generation")
    private lazy var generationValueLabel = makeValueLabel()

    private lazy var captureRateLabel = makeHeaderLabel(text: "Capture Rate")
    private lazy var captureValueLabel = makeValueLabel(textColor: .tintColor)

    private lazy var ringView: CircularProgressBarView = {
        let view = CircularProgressBarView()

        view.genderImage = UIImage(resource: .rateIcon)
        view.trackColor = #colorLiteral(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
        view.progressColor = #colorLiteral(red: 0.331, green: 0.621, blue: 0.874, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false

        let height = view.heightAnchor.constraint(equalToConstant: 40)
        height.priority = .defaultHigh

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 40),
            height
        ])

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: CaptureInfo) {
        habitatValueLabel.text = model.habitat
        generationValueLabel.text = model.generation
        captureValueLabel.text = "\(model.captureRate)%"
        ringView.setProgress(percentage: CGFloat(model.captureRate), animated: true)
    }
}

private extension CaptureCell {

    func setupViews() {
        let column1 = makeInfoStack(title: habitatLabel, value: habitatValueLabel)
        let column2 = makeInfoStack(title: generationLabel, value: generationValueLabel)

        let captureContentStack = UIStackView(arrangedSubviews: [captureValueLabel, ringView])

        captureContentStack.axis = .horizontal
        captureContentStack.alignment = .center
        captureContentStack.spacing = 5

        let column3 = makeInfoStack(title: captureRateLabel, value: captureContentStack)

        configureColumns([column1, column2, column3])
    }

    func makeHeaderLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .tintColor
        return label
    }

    func makeValueLabel(textColor: UIColor = .label) -> UILabel {
        let label = UILabel()

        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = textColor

        return label
    }

    func makeInfoStack(title: UIView, value: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [title, value])

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12

        return stack
    }

    func makeSeparator() -> UIView {
        let view = UIView()

        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }
}
