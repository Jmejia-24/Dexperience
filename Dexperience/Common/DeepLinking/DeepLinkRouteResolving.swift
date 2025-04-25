//
//  DeepLinkRouteResolving.swift
//  Dexperience
//
//  Created by Byron on 4/24/25.
//

import Foundation

protocol DeepLinkRouteResolving {

    func appTransition(for deepLink: DeepLink) -> AppTransition?
    func tabFor(_ deepLink: DeepLink) -> TabBarTransition?
}
