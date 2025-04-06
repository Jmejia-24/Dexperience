//
//  GradientProvider.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

struct GradientProvider {

    static func make(style: GradientStyle, direction: GradientDirection = .horizontal) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = style.colors.map { $0.cgColor }

        switch direction {
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        }

        return gradient
    }
}

