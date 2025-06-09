//
//  ImageLoader.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import UIKit
import Combine

final class ImageLoader {
    //MARK: Private properties
    static let shared = ImageLoader()

    //MARK: Exposed properties
    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    //MARK: Exposed methods
    func loadImage(from url: URL) async -> UIImage? {
        let urlString = url.absoluteString as NSString
        if let cachedImage = cache.object(forKey: urlString) {
            return cachedImage
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            self.cache.setObject(image, forKey: urlString)
            return image
        } catch {
            print("Error loading image: \(error.localizedDescription)")
            return nil
        }
    }
}
