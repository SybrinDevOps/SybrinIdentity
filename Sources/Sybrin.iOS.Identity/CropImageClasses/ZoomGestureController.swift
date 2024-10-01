

import Foundation
import AVFoundation
import UIKit

final class ZoomGestureController {
    
    private let image: UIImage
    private let rectView: RectangleView
    
    init(image: UIImage, rectView: RectangleView) {
        self.image = image
        self.rectView = rectView
    }
    
    private var previousPanPosition: CGPoint?
    private var closestCorner: CornerPosition?
    
    @objc func handle(pan: UIGestureRecognizer) {
        guard let drawnRect = rectView.rect else {
            return
        }
        
        guard pan.state != .ended else {
            self.previousPanPosition = nil
            self.closestCorner = nil
            rectView.resetHighlightedCornerViews()
            return
        }
        
        let position = pan.location(in: rectView)
        
        let previousPanPosition = self.previousPanPosition ?? position
        let closestCorner = self.closestCorner ?? position.closestCornerFrom(rect: drawnRect)
        
        let offset = CGAffineTransform(translationX: position.x - previousPanPosition.x, y: position.y - previousPanPosition.y)
        let cornerView = rectView.cornerViewForCornerPosition(position: closestCorner)
        let draggedCornerViewCenter = cornerView.center.applying(offset)
        
        rectView.moveCorner(cornerView: cornerView, atPoint: draggedCornerViewCenter)
        
        self.previousPanPosition = position
        self.closestCorner = closestCorner
        
        let scale = image.size.width / rectView.bounds.size.width
        let scaledDraggedCornerViewCenter = CGPoint(x: draggedCornerViewCenter.x * scale, y: draggedCornerViewCenter.y * scale)
        guard let zoomedImage = image.scaledImage(atPoint: scaledDraggedCornerViewCenter, scaleFactor: 2.5, targetSize: rectView.bounds.size) else {
            return
        }
        
        rectView.highlightCornerAtPosition(position: closestCorner, with: zoomedImage)
    }
}
