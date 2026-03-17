import SwiftUI
import UIKit
import Combine

enum ImageUtils {
    private static var displayScale: CGFloat {
        // Fallback for getting screen scale in modern iOS
        #if os(iOS)
        return (UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)?
            .screen.scale ?? 2.0
        #else
        return 2.0
        #endif
    }

    static func downsample(imageAt url: URL, to pointSize: CGSize, scale: CGFloat? = nil) -> UIImage? {
        let actualScale = scale ?? displayScale
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOptions) else { return nil }
        
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * actualScale
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
        return UIImage(cgImage: downsampledImage)
    }
    
    static func downsample(image: UIImage, to pointSize: CGSize, scale: CGFloat? = nil) -> UIImage? {
        let actualScale = scale ?? displayScale
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else { return nil }
        
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * actualScale
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
        return UIImage(cgImage: downsampledImage)
    }
}
