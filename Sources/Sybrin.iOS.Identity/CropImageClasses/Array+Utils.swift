

import Foundation

extension Array where Element == Rectangle {
    
    /// Finds the biggest rectangle within an array of `Rectangle` objects.
    func biggest() -> Rectangle? {
        let biggestRectangle = self.max(by: { (rect1, rect2) -> Bool in
            return rect1.perimeter < rect2.perimeter
        })
        
        return biggestRectangle
    }
}
