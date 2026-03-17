import SwiftUI
import Vision
import UIKit
import Combine

struct IrisInfo: Codable {
    let hexColor: String
    let colorName: String
    let pattern: String
    let confidence: Double
}

enum IrisAnalysisUtils {
    
    /// Detects iris information from a captured eye image
    static func detectIrisInfo(from image: UIImage) -> IrisInfo? {
        guard let cgImage = image.cgImage else { return nil }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
        let faceRequest = VNDetectFaceLandmarksRequest()
        
        do {
            try requestHandler.perform([faceRequest])
            
            guard let observations = faceRequest.results,
                  let face = observations.first,
                  let landmarks = face.landmarks,
                  let leftEye = landmarks.leftEye else {
                return fallbackIrisInfo()
            }
            
            // 1. Get eye region
            let eyePoints = leftEye.normalizedPoints
            let boundingBox = face.boundingBox
            
            // Calculate a slightly larger crop for the iris area
            let minX = eyePoints.map { $0.x }.min() ?? 0
            let maxX = eyePoints.map { $0.x }.max() ?? 1
            let minY = eyePoints.map { $0.y }.min() ?? 0
            let maxY = eyePoints.map { $0.y }.max() ?? 1
            
            let width = maxX - minX
            let height = maxY - minY
            
            // Adjust to CGImage coordinates (flipped Y)
            let imageWidth = CGFloat(cgImage.width)
            let imageHeight = CGFloat(cgImage.height)
            
            let cropRect = CGRect(
                x: (boundingBox.minX + minX * boundingBox.width) * imageWidth,
                y: (1 - (boundingBox.minY + maxY * boundingBox.height)) * imageHeight,
                width: width * boundingBox.width * imageWidth,
                height: height * boundingBox.height * imageHeight
            )
            
            guard let eyeImage = cgImage.cropping(to: cropRect) else {
                return fallbackIrisInfo()
            }
            
            // 2. Extract Dominant Color from Center
            let dominantColor = extractDominantColor(from: eyeImage)
            let hex = dominantColor.toHexString()
            let (colorName, pattern) = analyzeColorAndPattern(color: dominantColor)
            
            return IrisInfo(
                hexColor: hex,
                colorName: colorName,
                pattern: pattern,
                confidence: Double(face.confidence)
            )
            
        } catch {
            print("Iris analysis failed: \(error)")
            return fallbackIrisInfo()
        }
    }
    
    private static func extractDominantColor(from cgImage: CGImage) -> UIColor {
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return .blue
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let data = context.data else { return .blue }
        let buffer = data.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel)
        
        var totalR: Int = 0
        var totalG: Int = 0
        var totalB: Int = 0
        
        // Sample middle 50% to avoid skin/eyelashes
        let startX = width / 4
        let endX = width * 3 / 4
        let startY = height / 4
        let endY = height * 3 / 4
        let count = (endX - startX) * (endY - startY)
        
        for y in startY..<endY {
            for x in startX..<endX {
                let pixelIndex = (y * width + x) * bytesPerPixel
                totalR += Int(buffer[pixelIndex])
                totalG += Int(buffer[pixelIndex + 1])
                totalB += Int(buffer[pixelIndex + 2])
            }
        }
        
        let avgR = CGFloat(totalR / count) / 255.0
        let avgG = CGFloat(totalG / count) / 255.0
        let avgB = CGFloat(totalB / count) / 255.0
        
        return UIColor(red: avgR, green: avgG, blue: avgB, alpha: 1.0)
    }
    
    private static func analyzeColorAndPattern(color: UIColor) -> (String, String) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // Simple heuristic for color naming
        let colorName: String
        let pattern: String
        
        if r > g && r > b {
            colorName = "Amber/Brown"
            pattern = "Stellar Crypts"
        } else if g > r && g > b {
            colorName = "Green/Hazel"
            pattern = "Verdant Furrows"
        } else if b > r && b > g {
            colorName = "Blue/Sapphire"
            pattern = "Celestial Rings"
        } else {
            colorName = "Mystic Gray"
            pattern = "Cosmic Clouds"
        }
        
        return (colorName, pattern)
    }
    
    private static func fallbackIrisInfo() -> IrisInfo {
        return IrisInfo(hexColor: "#4A90E2", colorName: "Deep Blue", pattern: "Oceanic Waves", confidence: 1.0)
    }
}

extension UIColor {
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
}
