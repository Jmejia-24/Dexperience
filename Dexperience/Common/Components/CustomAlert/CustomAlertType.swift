//
//  CustomAlertType.swift
//  Dexperience
//
//  Created by Byron on 4/20/25.
//

import UIKit

enum CustomAlertType {

    case error
    case success
    case warning
    case info

    var icon: UIImage? {
        switch self {
        case .error:
            return UIImage(systemName: "xmark.octagon")
        case .success:
            return UIImage(systemName: "checkmark.seal")
        case .warning:
            return UIImage(systemName: "exclamationmark.triangle")
        case .info:
            return UIImage(systemName: "info.circle")
        }
    }

    var tintColor: UIColor {
        switch self {
        case .error:
            return .systemRed
        case .success:
            return .systemGreen
        case .warning:
            return .systemOrange
        case .info:
            return .systemBlue
        }
    }
}
