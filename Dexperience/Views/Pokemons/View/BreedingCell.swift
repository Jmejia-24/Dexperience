//
//  BreedingCell.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

import UIKit

final class BreedingCell: TripleColumnBaseCell {

    private lazy var eggGroupLabel = makeHeaderLabel(text: "Egg Group")
    private lazy var eggGroupValueLabel = makeValueLabel()

    private lazy var hatchTimeLabel = makeHeaderLabel(text: "Hatch Time")
    private lazy var hatchTimeValueLabel = makeValueLabel()

    private lazy var genderLabel = makeHeaderLabel(text: "Gender")
    private lazy var femaleLabel = makeValueLabel(textColor: #colorLiteral(red: 0.808501184, green: 0.4426948726, blue: 0.8835668564, alpha: 1))
    private lazy var maleLabel = makeValueLabel(textColor: #colorLiteral(red: 0.5007841587, green: 0.7130070329, blue: 0.9571134448, alpha: 1))

    private lazy var ringView: CircularProgressBarView = {
        let view = CircularProgressBarView()

        view.genderImage = UIImage(resource: .genderIcon)
        view.trackColor = #colorLiteral(red: 0.5007841587, green: 0.7130070329, blue: 0.9571134448, alpha: 1)
        view.progressColor = #colorLiteral(red: 0.808501184, green: 0.4426948726, blue: 0.8835668564, alpha: 1)
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

    func configure(with model: BreedingInfo) {
        eggGroupLabel.text = "Egg Group"
        eggGroupValueLabel.text = model.eggGroups.joined(separator: "\n")

        hatchTimeLabel.text = "Hatch Time"
        hatchTimeValueLabel.text = "\(model.hatchSteps) Steps\n\(model.hatchCycles) Cycles"

        genderLabel.text = "Gender"
        femaleLabel.text = "\(model.genderRatio.female)%"
        maleLabel.text = "\(model.genderRatio.male)%"

        ringView.setProgress(percentage: model.genderRatio.female, animated: true)
    }
}

private extension BreedingCell {

    func setupViews() {
        let column1 = makeInfoStack(title: eggGroupLabel, value: eggGroupValueLabel)
        let column2 = makeInfoStack(title: hatchTimeLabel, value: hatchTimeValueLabel)

        let labelsStack = UIStackView(arrangedSubviews: [femaleLabel, maleLabel])

        labelsStack.axis = .vertical
        labelsStack.alignment = .center
        labelsStack.spacing = 2

        let genderInfoStack = UIStackView(arrangedSubviews: [labelsStack, ringView])

        genderInfoStack.axis = .horizontal
        genderInfoStack.alignment = .center
        genderInfoStack.spacing = 5

        let column3 = UIStackView(arrangedSubviews: [genderLabel, genderInfoStack])

        column3.axis = .vertical
        column3.alignment = .center
        column3.spacing = 12

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

    func makeInfoStack(title: UILabel, value: UILabel) -> UIStackView {
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
