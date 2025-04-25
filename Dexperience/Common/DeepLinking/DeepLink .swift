//
//  DeepLink .swift
//  Dexperience
//
//  Created by Byron on 4/24/25.
//

enum DeepLink {

    case pokemonDetail(id: String)
    case moveDetail(id: String)
    case itemDetail(id: String)
    case tab(TabBarTransition)
}
