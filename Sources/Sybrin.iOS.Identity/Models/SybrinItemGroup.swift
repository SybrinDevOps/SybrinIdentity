//
//  SybrinItemGroup.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/07/19.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import MLKitFaceDetection  ////import MLKit

struct SybrinItemGroup {
    
    // MARK: Internal Properties
    var Lines: [SybrinLine]
    var Elements: [SybrinElement]
    
    init() {
        Lines = []
        Elements = []
    }
    
}
