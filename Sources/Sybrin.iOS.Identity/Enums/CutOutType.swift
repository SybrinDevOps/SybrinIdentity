import UIKit
import Foundation

@objc public enum CutOutType: Int {
    case DEFAULT
    case PASSPORT
    case ID_CARD
    case ACCESS_CARD
    case BOOK
    case A4
    case A4_LANDSCAPE
    case NONE
}

@objc public enum HasBackSide: Int {
    case DEFAULT
    case TRUE
    case FALSE
}