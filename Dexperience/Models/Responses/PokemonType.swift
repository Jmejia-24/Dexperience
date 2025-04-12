//
//  PokemonType.swift
//  Dexperience
//
//  Created by Byron on 4/8/25.
//

import UIKit

enum PokemonType: String, CaseIterable {

    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
}

extension PokemonType {

    var image: UIImage {
        UIImage(named: "type_\(self.rawValue)") ?? UIImage()
    }

    var tagImage: UIImage {
        UIImage(named: "tag_\(self.rawValue)") ?? UIImage()
    }

    var color: UIColor {
        UIColor(named: "color_\(self.rawValue)") ?? .tintColor
    }
}
