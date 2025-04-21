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
    private var currentURL: URL?

    init(placeholderImage: UIImage? = UIImage(resource: .placeholder)) {
        self.placeholderImage = placeholderImage
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadImage(from url: URL?) {
        guard url != currentURL else { return }

        currentURL = url
        image = placeholderImage

        spinner.startAnimating()
        task?.cancel()

        guard let url else {
            spinner.stopAnimating()
            return
        }

        task = Task {
            let image = await SharedImageLoader.shared.loadImage(from: url)

            await MainActor.run {
                guard url == currentURL else { return }

                self.image = image ?? placeholderImage

                spinner.stopAnimating()
            }
        }
    }

    func reset() {
        task?.cancel()
        image = placeholderImage
        spinner.stopAnimating()
        currentURL = nil
    }

    func prepareForReuse() {
        image = placeholderImage

        spinner.stopAnimating()
    }
}

private extension AsyncCachedImageView {

    func setup() {
        image = placeholderImage
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
