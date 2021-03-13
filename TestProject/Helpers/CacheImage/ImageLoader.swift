import UIKit

final class ImageLoader {
    
    private static let imageCache = NSCache<AnyObject,UIImage>()
    
    static func loadImage(path: String, needCaching: Bool = true,
                          completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let url = URL(string: path) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    debugPrint("Couldn't download image: ", error)
                    return
                }
                
                guard let data = data,
                      let image = UIImage(data: data),
                      let resizedImage = image.resized(quality: .low) else { return }
                
                if needCaching {
                    imageCache.setObject(resizedImage, forKey: path as NSString)
                }
                
                completion(resizedImage)
            }.resume()
        }
    }
    
    static func loadImageIfNeeded(path: String, completion: @escaping (UIImage?) -> ()) {
        if let cacheImage = imageFromCach(path) {
            completion(cacheImage)
            return
        }
        
        loadImage(path: path, completion: completion)
    }
    
    private static func imageFromCach(_ path: String) -> UIImage? {
        return imageCache.object(forKey: path as NSString)
    }
}

private extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func resized(quality: JPEGQuality, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * quality.rawValue, height: size.height * quality.rawValue)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
