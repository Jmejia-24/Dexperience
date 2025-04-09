//
//  ImageCacheManager.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

import UIKit

final class ImageCacheManager {

    static let shared = ImageCacheManager()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let diskCacheURL: URL?
    private let maxDiskSize: Int = 100 * 1024 * 1024 // 100MB
    private let expirationDays: Int = 7

    private init() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first

        diskCacheURL = cachesDirectory?.appendingPathComponent("ImageCache", isDirectory: true)

        if let diskCacheURL, !fileManager.fileExists(atPath: diskCacheURL.path) {
            try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        }

        cleanupIfNeeded()
    }

    // MARK: - Public

    func image(for url: URL) -> UIImage? {
        let key = url.absoluteString as NSString

        if let image = memoryCache.object(forKey: key) {
            return image
        }

        guard let fileURL = diskCacheURL?.appendingPathComponent(key.hashedFilename()),
              let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {

            return nil
        }

        memoryCache.setObject(image, forKey: key)
        return image
    }

    func save(image: UIImage, for url: URL) {
        let key = url.absoluteString as NSString

        memoryCache.setObject(image, forKey: key)


        guard let fileURL = diskCacheURL?.appendingPathComponent(key.hashedFilename()),
              let data = image.pngData() else { return }

        try? data.write(to: fileURL, options: [.atomic])

        cleanupIfNeeded()
        removeExpiredFiles()
    }

    func clearAllCache() {
        guard let diskCacheURL else { return }

        memoryCache.removeAllObjects()

        try? fileManager.removeItem(at: diskCacheURL)
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }

    func listCachedFiles() -> [String] {
        guard let path = diskCacheURL?.path,
              let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }

        return files
    }
}

// MARK: - Private

private extension ImageCacheManager {

    func cleanupIfNeeded() {
        guard let diskCacheURL else { return }

        let resourceKeys: Set<URLResourceKey> = [.isDirectoryKey, .totalFileAllocatedSizeKey, .contentModificationDateKey]

        guard let files = try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: Array(resourceKeys)) else { return }

        var totalSize = 0
        var fileInfos: [(url: URL, size: Int, date: Date)] = []

        for fileURL in files {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                  resourceValues.isDirectory == false,
                  let fileSize = resourceValues.totalFileAllocatedSize,
                  let fileDate = resourceValues.contentModificationDate else {
                continue
            }

            totalSize += fileSize

            fileInfos.append((url: fileURL, size: fileSize, date: fileDate))
        }

        guard totalSize > maxDiskSize else { return }

        let sortedFiles = fileInfos.sorted { $0.date < $1.date }
        var bytesToRemove = totalSize - maxDiskSize

        for file in sortedFiles {
            try? fileManager.removeItem(at: file.url)
            bytesToRemove -= file.size
            if bytesToRemove <= 0 { break }
        }
    }

    func removeExpiredFiles() {
        guard let diskCacheURL else { return }

        let resourceKeys: Set<URLResourceKey> = [.isDirectoryKey, .contentModificationDateKey]

        guard let files = try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: Array(resourceKeys)) else { return }

        let expirationInterval: TimeInterval = Double(expirationDays * 24 * 60 * 60)
        let now = Date()

        for fileURL in files {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                  resourceValues.isDirectory == false,
                  let fileDate = resourceValues.contentModificationDate else {
                continue
            }

            if now.timeIntervalSince(fileDate) > expirationInterval {
                try? fileManager.removeItem(at: fileURL)
            }
        }
    }
}
