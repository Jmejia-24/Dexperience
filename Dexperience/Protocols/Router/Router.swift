//
//  Router.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

import UIKit

protocol Router {

    associatedtype Route

    var navigationController: AppNavigationController? { get set }

    func process(route: Route)
    func exit()
}
