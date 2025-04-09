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

    var imageName: String {
        "type_\(self.rawValue)"
    }

    var image: UIImage {
        UIImage(named: imageName) ?? UIImage()
    }
}
