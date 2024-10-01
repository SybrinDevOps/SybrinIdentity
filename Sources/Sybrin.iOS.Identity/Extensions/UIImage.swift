//
//  UIImage.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/03.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit

extension UIImage {
    
    func GetCropRect(_ leftOffset: CGFloat, _ topOffset: CGFloat, _ widthOffset: CGFloat, _ heightOffset: CGFloat, _ frame: CGRect) -> CGRect {
        let imageWidth = self.size.width
        let imageHeight = self.size.height
        
        var x: Int = Int(frame.minX - (frame.size.width * leftOffset))
        x = x <= 0 ? 0 : x
        x = x >= Int(imageWidth) ? Int(imageWidth) : x
        
        var y: Int = Int(frame.minY - (frame.size.height * topOffset))
        y = y <= 0 ? 0 : y
        y = y >= Int(imageHeight) ? Int(imageHeight) : y
        
        var width: Int = Int(frame.size.width * widthOffset)
        width = width <= 0 ? 1: width
        width = (x + width) > Int(imageWidth) ? (Int(imageWidth) - x) : width
        
        var height: Int = Int(frame.size.height * heightOffset)
        height = height <= 0 ? 1 : height
        height = (y + height) > Int(imageHeight) ? (Int(imageHeight) - y) : height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func CropImage(_ rect: CGRect, padding: CGFloat = 0) -> UIImage {
        return CropImage(rect, paddingVertical: padding, paddingHorizontal: padding)
    }
    
    func CropImage(_ rect: CGRect, paddingVertical: CGFloat = 0, paddingHorizontal: CGFloat = 0) -> UIImage {
        let croppedCGImageOptional = self.cgImage?.cropping(to: CGRect(x: rect.minX - paddingHorizontal, y: rect.minY - paddingVertical, width: rect.width + paddingHorizontal * 2, height: rect.height + paddingVertical * 2))

        guard let croppedCGImage = croppedCGImageOptional else {
            "CGImage was nil".log(.Error)
            return self
        }

        return UIImage(cgImage: croppedCGImage)
    }
    
}

extension UIView {

    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }

}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func convertToGrayScale() -> UIImage {

        // Create image rectangle with current image width/height
        let imageRect:CGRect = CGRect(x:0, y:0, width:self.size.width, height: self.size.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = self.size.width
        let height = self.size.height

        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(self.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()

        return UIImage(cgImage: imageRef!)
    }
}

extension UIImage {
    var flattened: UIImage? {
        let ciImage = CIImage(image: self)!

        guard let openGLContext = EAGLContext(api: .openGLES2) else { return nil }
        let ciContext =  CIContext(eaglContext: openGLContext)

        let detector = CIDetector(ofType: CIDetectorTypeRectangle,
                                  context: ciContext,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!

        guard let rect = detector.features(in: ciImage).first as? CIRectangleFeature
            else { return nil }

        let perspectiveCorrection = CIFilter(name: "CIPerspectiveCorrection")!
        perspectiveCorrection.setValue(CIVector(cgPoint: rect.topLeft),
                                       forKey: "inputTopLeft")
        perspectiveCorrection.setValue(CIVector(cgPoint: rect.topRight),
                                       forKey: "inputTopRight")
        perspectiveCorrection.setValue(CIVector(cgPoint: rect.bottomRight),
                                       forKey: "inputBottomRight")
        perspectiveCorrection.setValue(CIVector(cgPoint :rect.bottomLeft),
                                       forKey: "inputBottomLeft")
        perspectiveCorrection.setValue(ciImage,
                                       forKey: kCIInputImageKey)


        if let output = perspectiveCorrection.outputImage,
            let cgImage = ciContext.createCGImage(output, from: output.extent) {
            
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }

        return nil
    }
    
    
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }
    
    func compressImage(quality: CGFloat) -> Data? {
        
        return self.jpegData(compressionQuality: quality)
    }
}

