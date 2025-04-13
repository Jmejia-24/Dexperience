//
//  CircularProgressBarView.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

import UIKit

final class CircularProgressBarView: UIView {

    // MARK: - Constants

    private struct Appearance {
        static let lineWidth: CGFloat = 5
    }

    // MARK: - Public API

    var genderImage: UIImage? {
        didSet { iconImageView.image = genderImage }
    }

    var progressColor: UIColor = .tintColor {
        didSet { progressLayer.strokeColor = progressColor.cgColor }
    }

    var trackColor: UIColor = .systemGray5 {
        didSet { backgroundLayer.strokeColor = trackColor.cgColor }
    }

    // MARK: - Layers

    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = Appearance.lineWidth
        layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = progressColor.cgColor
        return layer
    }()

    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = Appearance.lineWidth
        layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = trackColor.cgColor
        return layer
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Setup

    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - Appearance.lineWidth) / 2

        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 1.5 * .pi,
            clockwise: true
        ).cgPath

        backgroundLayer.path = circlePath
        progressLayer.path = circlePath

        backgroundLayer.frame = bounds
        progressLayer.frame = bounds
    }

    // MARK: - Public Method

    func setProgress(percentage: CGFloat, animated: Bool) {
        let normalized = max(min(percentage / 100, 1), 0)

        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.presentation()?.strokeEnd ?? progressLayer.strokeEnd
            animation.toValue = normalized
            animation.duration = 0.5
            animation.timingFunction = .init(name: .easeInEaseOut)
            progressLayer.add(animation, forKey: "progress")
        }

        progressLayer.strokeEnd = normalized
    }
}

private extension CircularProgressBarView {

    func setupLayout() {
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
        addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            iconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45)
        ])
    }
}
