//
//  PokemonDetailHeaderView.swift
//  Dexperience
//
//  Created by Byron on 4/13/25.
//

import UIKit

final class PokemonDetailHeaderView: UIView {

    private var buttons: [UIButton] = []
    private var currentTab: Tab = .stats

    weak var delegate: HeaderDelegate?

    private let pokemonImageView: AsyncCachedImageView = {
        let imageView = AsyncCachedImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 40, weight: .light)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let flavorLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var tagStackView: UIStackView = {
        let stack = UIStackView()

        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally

        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, tagStackView, flavorLabel])

        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 16

        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    private let tabStackView: UIStackView = {
        let stack = UIStackView()

        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 16

        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()

    var totalHeight: CGFloat {
        pokemonImageView.frame.height + mainStackView.frame.height
    }

    var pokemonImage: UIImage? {
        pokemonImageView.image
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        layout()
        configureTabs()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        updateSelection(animated: false)
    }

    func setAlpha(_ value: CGFloat) {
        pokemonImageView.alpha = value
        mainStackView.alpha = value
    }

    func configure(_ pokemon: Pokemon) {

        if let imageUrl = URL(string: pokemon.sprites?.other?.officialArtwork?.frontDefault ?? "") {
            pokemonImageView.loadImage(from: imageUrl)
        }

        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if let types = pokemon.types {
            let images: [UIImage] = types.compactMap { typeInfo in
                guard let name = typeInfo.type?.name else { return nil }

                return PokemonType(rawValue: name)?.tagImage
            }

            updateTagStack(with: images)

            tagStackView.isHidden = images.isEmpty
        } else {
            tagStackView.isHidden = true
        }

        nameLabel.text = pokemon.name?.formatted
    }

    func configureFlavorText(_ text: String?) {
        flavorLabel.text = text
    }
}

private extension PokemonDetailHeaderView {

    func layout() {
        addSubview(pokemonImageView)
        addSubview(mainStackView)
        addSubview(tabStackView)

        NSLayoutConstraint.activate([
            pokemonImageView.heightAnchor.constraint(equalToConstant: 170),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 170),
            pokemonImageView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            pokemonImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            mainStackView.topAnchor.constraint(equalToSystemSpacingBelow: pokemonImageView.bottomAnchor, multiplier: 2),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: tabStackView.topAnchor, constant: -32),

            tabStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            tabStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            tabStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func updateTagStack(with images: [UIImage]) {
        images.forEach { image in
            let imageView = UIImageView(image: image)

            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 120),
                imageView.heightAnchor.constraint(equalToConstant: 40)
            ])

            tagStackView.addArrangedSubview(imageView)
        }
    }

    func configureTabs() {
        Tab.allCases.forEach { tab in
            let button = UIButton(type: .custom)

            button.setTitle(tab.rawValue, for: .normal)
            button.setTitleColor(tintColor, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            button.layer.cornerRadius = 20
            button.layer.masksToBounds = false
            button.tag = tab.hashValue

            button.translatesAutoresizingMaskIntoConstraints = false

            let height = button.heightAnchor.constraint(equalToConstant: 40)
            height.priority = .defaultHigh

            NSLayoutConstraint.activate([ height ])

            button.addAction(UIAction(handler: { [weak self] _ in
                self?.tabTapped(button)
            }), for: .touchUpInside)

            buttons.append(button)
            tabStackView.addArrangedSubview(button)
        }

        updateSelection(animated: false)
    }

    func updateSelection(animated: Bool) {
        buttons.forEach { button in
            let isSelected = button.tag == currentTab.hashValue
            let background = isSelected ? tintColor : .clear
            let textColor = isSelected ? .white : tintColor
            let shadowOpac = isSelected ? Float(0.5) : 0
            let shadowRadius = isSelected ? CGFloat(10) : 0

            let apply = {
                button.backgroundColor = background
                button.setTitleColor(textColor, for: .normal)

                button.layer.shadowColor = self.tintColor.cgColor
                button.layer.shadowOpacity = shadowOpac
                button.layer.shadowOffset = .zero
                button.layer.shadowRadius = shadowRadius

                let path = UIBezierPath(
                    roundedRect: button.bounds,
                    cornerRadius: button.layer.cornerRadius
                )

                button.layer.shadowPath = path.cgPath
            }

            if animated {
                UIView.animate(withDuration: 0.2, animations: apply)
            } else {
                apply()
            }
        }
    }

    func tabTapped(_ sender: UIButton) {
        guard let tab = Tab.allCases.first(where: { $0.hashValue == sender.tag }) else { return }

        currentTab = tab

        updateSelection(animated: true)
        delegate?.didSelectTab(at: tab)
    }
}
