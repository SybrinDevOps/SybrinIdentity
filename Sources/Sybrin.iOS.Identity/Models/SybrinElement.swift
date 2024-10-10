//
//  SybrinElement.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/07/19.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import CoreGraphics

struct SybrinElement : ProtocolSybrinItem {
    
    // MARK: Internal Properties
    var Text: String
    var Frame: CGRect
    
    init(text: String, frame: CGRect) {
        Text = text
        Frame = frame
    }
    
}
