//
//  GradientStyle.swift
//  Dexperience
//
//  Created by Byron on 4/5/25.
//

import UIKit

enum GradientStyle {
    case primary
    case tabBarLine
    case custom([UIColor])

    var colors: [UIColor] {
        switch self {
        case .primary, .tabBarLine:
            return [
                UIColor(.primaryGradientStart),
                UIColor(.primaryGradientMid),
                UIColor(.brandGradientEnd)
            ]
        case .custom(let customColors):
            return customColors
        }
    }
}
