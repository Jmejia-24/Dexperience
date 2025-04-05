//
//  Coordinator.swift
//  Dexperience
//
//  Created by Byron on 4/4/25.
//

import UIKit

protocol Coordinator {

    func start()
    var primaryViewController: UIViewController { get }
}
