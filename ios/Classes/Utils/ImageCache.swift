//
// Created by Valentin Grigorean on 09.04.2021.
//

import Foundation

final class ImageCache {
    private lazy var imageCache: NSCache<BitmapDescriptorOptions, UIImage> = {
        let cache = NSCache<BitmapDescriptorOptions, UIImage>()
        cache.totalCostLimit = 1024 * 1024 * 10
        return cache
    }()

    public static let sharedInstance = ImageCache()

    public func image(for bitmapDescriptorOptions: BitmapDescriptorOptions) -> UIImage? {
        let cache = imageCache
        if let cacheImage = cache.object(forKey: bitmapDescriptorOptions){
            return cacheImage
        }
        return nil
    }

    public func insertImage(_ image: UIImage?,
                            for bitmapDescriptorOptions: BitmapDescriptorOptions) {
        guard let image = image else {
            return removeImage(for: bitmapDescriptorOptions)
        }
        imageCache.setObject(image, forKey: bitmapDescriptorOptions, cost: image.diskSize)
    }

    public func removeImage(for bitmapDescriptorOptions: BitmapDescriptorOptions) {
        imageCache.removeObject(forKey: bitmapDescriptorOptions)
    }
}

fileprivate extension UIImage {
    var diskSize: Int {
        guard let cgImage = cgImage else {
            return 0
        }
        return cgImage.bytesPerRow * cgImage.height
    }
}
