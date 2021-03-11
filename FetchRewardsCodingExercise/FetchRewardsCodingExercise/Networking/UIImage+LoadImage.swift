// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// UIImage+LoadImage.swift

import UIKit

extension UIImageView {

    private static var imageCache = NSCache<NSString, UIImage>()

    func loadImage(with urlString: String, completion: @escaping () -> Void) {
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "photo")
        }

        guard let url = URL(string: urlString) else { return }

        if let cachedImage = UIImageView.imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async { [weak self] in
                self?.image = cachedImage
            }
        } else {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data, let downloadedImage = UIImage(data: data) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.image = downloadedImage
                }
            }.resume()
        }

    }

}
