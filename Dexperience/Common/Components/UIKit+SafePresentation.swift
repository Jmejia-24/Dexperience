//
//  UIKit+SafePresentation.swift
//  Dexperience
//
//  Created by Byron on 4/24/25.
//

import UIKit

func safePresent(from presenter: UIViewController?, viewController: UIViewController) {
    guard let presenter, presenter.view.window != nil else {
        DispatchQueue.main.async {
            safePresent(from: presenter, viewController: viewController)
        }

        return
    }

    presenter.present(viewController, animated: true)
}
