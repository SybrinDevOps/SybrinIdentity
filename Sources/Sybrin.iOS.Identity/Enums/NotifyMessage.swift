//
//
//  NotifyMessage.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

enum NotifyMessage {
    case Lighting
    case Help
    
    case ScanDocument
    case ScanFrontCard
    case ScanBackCard
    case TimeExpired
    case NiceYouGotIt
    case Empty
    
    case GetReadyToScan(time: Int)
    case TimeRemaining(topLine: String?, timeRemaining: Int)
    case DetectionFailed(for: String?)
    
    case ScanningIn(timeRemaining: Int)
    case TakingSelfie(timeRemaining: Int)
    
    case Manual(message: String)
    
    var stringValue: String {
        
        switch SybrinIdentity.shared.configuration?.language {
            
        case .FILIPINO:
            switch self {
                case .Lighting: return "Having trouble scanning? Make sure you have good lighting, or try the flash"
                case .Help: return "Siguraduhin na ang document ay nasa loob ng frame at nasa maliwanag na lugar"
                    
            case .ScanDocument: return "I-scan ang harapan ng document"
            case .ScanFrontCard: return "I-scan ang harapan ng card"
                case .ScanBackCard: return "I-scan ang likuran ng card"
                case .TimeExpired: return "Time expired"
                case .NiceYouGotIt: return "Nice! Yun oh!"
                case .Empty: return ""
                    
            case .GetReadyToScan(time: let time): return "Get ready to scan in" + " \(time)"
                case .TimeRemaining(topLine: let topLine, timeRemaining: let timeRemaining):
                    if let topLine = topLine {
                        return "\(topLine)\nNatitirang time: \(timeRemaining)"
                    } else {
                        return "Natitirang time:" + ": \(timeRemaining)"
                    }
                case .DetectionFailed(for: let identityNumber):
                    if let identityNumber = identityNumber {
                        return "Failed detection" + " " + "for" + " \(identityNumber)"
                    } else {
                        return "Failed detection"
                    }
                case .ScanningIn(timeRemaining: let timeRemaining): return "Kasalukuyang nag-iiscan:" + ": \(timeRemaining)"
                case .TakingSelfie(timeRemaining: let timeRemaining): return "Kinukuhaan ka na ng selfie" + " \(timeRemaining)"
                    
                case .Manual(message: let message): return message
            }
        case .ENGLISH:
            switch self {
                case .Lighting: return "Having trouble scanning? Make sure you have good lighting, or try the flash"
                case .Help: return "Keep document in frame and under good lighting conditions"
                    
            case .ScanDocument: return "Scan the document"
            case .ScanFrontCard: return "Capture the front side"
                case .ScanBackCard: return "Capture the back side"
                case .TimeExpired: return "Time expired"
                case .NiceYouGotIt: return "Nice, you got it"
                case .Empty: return ""
                    
            case .GetReadyToScan(time: let time): return "Get ready to scan in" + " \(time)"
                case .TimeRemaining(topLine: let topLine, timeRemaining: let timeRemaining):
                    if let topLine = topLine {
                        return "\(topLine)\nTime left: \(timeRemaining)"
                    } else {
                        return "Time left" + ": \(timeRemaining)"
                    }
                case .DetectionFailed(for: let identityNumber):
                    if let identityNumber = identityNumber {
                        return "Failed detection" + " " + "for" + " \(identityNumber)"
                    } else {
                        return "Failed detection"
                    }
                case .ScanningIn(timeRemaining: let timeRemaining): return "Scan/Capture in" + ": \(timeRemaining)"
                case .TakingSelfie(timeRemaining: let timeRemaining): return "Taking selfie in" + " \(timeRemaining)"
                    
                case .Manual(message: let message): return message
            }
        default:
            switch self {
                case .Lighting: return "Having trouble scanning? Make sure you have good lighting, or try the flash"
                case .Help: return "Keep document in frame and under good lighting conditions"
                    
            case .ScanDocument: return "Scan the document"
            case .ScanFrontCard: return "Scan the front"
                case .ScanBackCard: return "Scan the back"
                case .TimeExpired: return "Time expired"
                case .NiceYouGotIt: return "Nice, you got it"
                case .Empty: return ""
                    
            case .GetReadyToScan(time: let time): return "Get ready to scan in" + " \(time)"
                case .TimeRemaining(topLine: let topLine, timeRemaining: let timeRemaining):
                    if let topLine = topLine {
                        return "\(topLine)\nTime left: \(timeRemaining)"
                    } else {
                        return "Time left" + ": \(timeRemaining)"
                    }
                case .DetectionFailed(for: let identityNumber):
                    if let identityNumber = identityNumber {
                        return "Failed detection" + " " + "for" + " \(identityNumber)"
                    } else {
                        return "Failed detection"
                    }
                case .ScanningIn(timeRemaining: let timeRemaining): return "Scan/Capture in" + ": \(timeRemaining)"
                case .TakingSelfie(timeRemaining: let timeRemaining): return "Taking selfie in" + " \(timeRemaining)"
                    
                case .Manual(message: let message): return message
            }
        }
    
    }
    
}
