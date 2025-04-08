//
//  AsyncCachedImageView.swift
//  Dexperience
//
//  Created by Byron on 4/7/25.
//

import UIKit

final class AsyncCachedImageView: UIImageView {

    private var task: Task<Void, Never>?
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let placeholderImage: UIImage?

    init(placeholderImage: UIImage? = #imageLiteral(resourceName: "PlaceholderImage")) {
        self.placeholderImage = placeholderImage
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadImage(from url: URL?) {
        image = placeholderImage
        spinner.startAnimating()

        task?.cancel()

        guard let url else {
            spinner.stopAnimating()
            return
        }

        if let cachedImage = ImageCacheManager.shared.image(for: url) {
            self.image = cachedImage
            spinner.stopAnimating()
            return
        }

        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                guard let downloadedImage = UIImage(data: data) else {
                    image = placeholderImage
                    spinner.stopAnimating()
                    return
                }

                ImageCacheManager.shared.save(image: downloadedImage, for: url)

                await MainActor.run {
                    self.image = downloadedImage
                    self.spinner.stopAnimating()
                }
            } catch {
                print("Error downloading image: \(error)")
                await MainActor.run {
                    image = placeholderImage
                    self.spinner.stopAnimating()
                }
            }
        }
    }

    func reset() {
        task?.cancel()
        image = placeholderImage
        spinner.stopAnimating()
    }
}

private extension AsyncCachedImageView {

    func setup() {
        contentMode = .scaleAspectFit
        clipsToBounds = true
        spinner.translatesAutoresizingMaskIntoConstraints = false

        addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
