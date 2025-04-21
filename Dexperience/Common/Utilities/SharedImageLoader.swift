//
//  SharedImageLoader.swift
//  Dexperience
//
//  Created by Byron on 4/20/25.
//

import UIKit

actor SharedImageLoader {
    static let shared = SharedImageLoader()

    private var inFlightTasks: [URL: Task<UIImage?, Never>] = [:]

    func loadImage(from url: URL) async -> UIImage? {
        if let existingTask = inFlightTasks[url] {
            return await existingTask.value
        }

        let task = Task<UIImage?, Never> {
            defer { Task { await self.clearTask(for: url) } }

            if let cached = ImageCacheManager.shared.image(for: url) {
                return cached
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else { return nil }

                ImageCacheManager.shared.save(image: image, for: url)
                return image
            } catch {
                print("❌ SharedImageLoader error:", error.localizedDescription)
                return nil
            }
        }

        inFlightTasks[url] = task

        return await task.value
    }

    private func clearTask(for url: URL) async {
        inFlightTasks[url] = nil
    }
}
