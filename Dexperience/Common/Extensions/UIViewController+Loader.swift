//
//  UIViewController+Loader.swift
//  Dexperience
//
//  Created by Byron on 4/23/25.
//

import UIKit

extension UIViewController {

    /// Executes an asynchronous operation that may throw an error while displaying a loader on top of the view controller.
    /// The loader is automatically shown before the operation starts and hidden after it completes or throws.
    ///
    /// Usage:
    /// ```
    /// Task {
    ///     do {
    ///         let result = try await withLoader {
    ///             try await fetchRemoteData()
    ///         }
    ///         print("Success:", result)
    ///     } catch {
    ///         print("Error:", error)
    ///     }
    /// }
    /// ```
    func withLoader<T>(_ operation: @escaping () async throws -> T) async throws -> T {
        try await LoaderView.shared.performWhileShowingLoader(in: view, operation)
    }

    /// Executes an asynchronous operation while displaying a loader on top of the view controller.
    /// The loader is automatically shown before the operation starts and hidden after it completes.
    ///
    /// Usage:
    /// ```
    /// Task {
    ///     await withLoader {
    ///         await preloadAssets()
    ///     }
    /// }
    /// ```
    func withLoader(_ operation: @escaping () async -> Void) async {
        await LoaderView.shared.performWhileShowingLoader(in: view, operation)
    }
}
