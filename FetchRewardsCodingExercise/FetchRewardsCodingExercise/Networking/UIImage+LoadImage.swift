// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// UIImage+LoadImage.swift

import UIKit

extension UIImageView {

    private static var imageCache = NSCache<NSString, UIImage>()

    func loadImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        var loadedImage: UIImage?

        if let cachedImage = UIImageView.imageCache.object(forKey: urlString as NSString) {
            loadedImage = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data, let downloadedImage = UIImage(data: data) else { return }
                loadedImage = downloadedImage
            }.resume()
        }

        DispatchQueue.main.async { [weak self] in
            self?.image = loadedImage
        }
    }
    
}
