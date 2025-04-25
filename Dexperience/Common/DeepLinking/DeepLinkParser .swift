//
//  DeepLinkParser .swift
//  Dexperience
//
//  Created by Byron on 4/24/25.
//

import Foundation

struct DeepLinkParser {

    func parse(url: URL) -> DeepLink? {
        guard let host = url.host,
              let domain = DeepLinkDomain(rawValue: host) else {
            return nil
        }

        let path = url.pathComponents.filter { $0 != "/" }

        switch domain {
        case .tab:
            return parseTabPath(path)
        }
    }
}

private extension DeepLinkParser {

    func parseTabPath(_ path: [String]) -> DeepLink? {
        guard let tabRaw = path.first, let tab = TabPath(rawValue: tabRaw) else { return nil }

        let detailID = path.dropFirst().first

        switch tab {
        case .pokemons:
            return detailID.map { .pokemonDetail(id: $0) } ?? .tab(.showPokemons)
        case .moves:
            return detailID.map { .moveDetail(id: $0) } ?? .tab(.showMoves)
        case .items:
            return detailID.map { .itemDetail(id: $0) } ?? .tab(.showItems)
        }
    }
}
