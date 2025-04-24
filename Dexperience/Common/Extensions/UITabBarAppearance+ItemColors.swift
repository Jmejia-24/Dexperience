//
//  UITabBarAppearance+ItemColors.swift
//  Dexperience
//
//  Created by Byron on 4/23/25.
//

import UIKit

extension UITabBarAppearance {
    /// Applies the same title and icon colors to all layout types (stacked, inline, compactInline).
    func applyItemColors(
        normalTitleColor: UIColor,
        normalIconColor: UIColor,
        selectedTitleColor: UIColor,
        selectedIconColor: UIColor
    ) {
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: normalTitleColor
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedTitleColor
        ]
        
        [stackedLayoutAppearance, inlineLayoutAppearance, compactInlineLayoutAppearance].forEach { layout in
            layout.normal.titleTextAttributes = normalAttributes
            layout.normal.iconColor = normalIconColor
            layout.selected.titleTextAttributes = selectedAttributes
            layout.selected.iconColor = selectedIconColor
        }
    }
}
