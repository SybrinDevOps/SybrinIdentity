//
//  SybrinLine.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/07/19.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import CoreGraphics

struct SybrinLine : ProtocolSybrinItem {
    
    // MARK: Internal Properties
    var Elements: [SybrinElement]
    var Text: String
    var Frame: CGRect
    
    init(text: String, frame: CGRect) {
        Elements = []
        Text = text
        Frame = frame
    }
    
}
