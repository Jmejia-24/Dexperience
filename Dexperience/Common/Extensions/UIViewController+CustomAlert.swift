//
//  UIViewController+CustomAlert.swift
//  Dexperience
//
//  Created by Byron on 4/21/25.
//

import UIKit

extension UIViewController {

    func presentAlert(
        type: CustomAlertType,
        message: String,
        primaryTitle: String = "OK",
        secondaryTitle: String? = nil,
        onPrimary: (() -> Void)? = nil,
        onSecondary: (() -> Void)? = nil
    ) {
        let alert = CustomAlertViewController(
            type: type,
            message: message,
            primaryTitle: primaryTitle,
            secondaryTitle: secondaryTitle,
            onPrimary: onPrimary,
            onSecondary: onSecondary
        )

        present(alert, animated: true)
    }
}
