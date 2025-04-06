//
//  UIView+Gradient.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

extension UIView {

    func applyGradient(style: GradientStyle, direction: GradientDirection = .horizontal) {
        let gradient = GradientProvider.make(style: style, direction: direction)
        gradient.frame = bounds

        layer.insertSublayer(gradient, at: 0)
    }

    func applyGradient(_ gradient: CAGradientLayer) {
        gradient.frame = bounds

        layer.insertSublayer(gradient, at: 0)
    }
}
