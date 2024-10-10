//
//  RectangleDetectionHandler.swift
//  Sybrin.iOS.DocumentScanner
//
//  Created by Default on 2021/11/23.
//

import Foundation
import CoreImage
import Vision
import CoreML
import UIKit

class RectangleDetectionHandler{
    
    public static func detectRectangle(image: UIImage) -> Rectangle?{
        
        let flippedImage = image.withHorizontallyFlippedOrientation()
        
        guard let ciImage = CIImage(image: flippedImage) else{
            return nil
        }
        
        let requestHandler = VNImageRequestHandler(ciImage: ciImage)
        let documentDetectionRequest = VNDetectRectanglesRequest()
        
        do{
            try requestHandler.perform([documentDetectionRequest])
            
//            guard let document = documentDetectionRequest.results?.first,
//                  let documentImage = ciImage.asUIImage?.flattened else {
//                      print("Failed to detect and crop document")
//                      return
//                  }
            
            guard let document = documentDetectionRequest.results?.first else {
                      return nil
                  }
            
            let topLeftPoint : CGPoint = CGPoint(x: image.size.width - (document.topLeft.x * image.size.width), y: document.topLeft.y * image.size.height)
            
            let topRightPoint : CGPoint = CGPoint(x: image.size.width - (document.topRight.x * image.size.width), y: document.topRight.y * image.size.height)
            
            let bottomLeftPoint : CGPoint = CGPoint(x: image.size.width - (document.bottomLeft.x * image.size.width), y: document.bottomLeft.y * image.size.height)
            
            let bottomRightPoint : CGPoint = CGPoint(x: image.size.width - (document.bottomRight.x * image.size.width), y: document.bottomRight.y * image.size.height)
    
            
            var scannedRect = Rectangle(topLeft: topLeftPoint, topRight: topRightPoint, bottomRight: bottomRightPoint, bottomLeft: bottomLeftPoint)
            scannedRect.reorganize()
            
            return scannedRect
            
        } catch{
            print("An error occured in rectangle detection")
            return nil
        }
    }
    
    
}
