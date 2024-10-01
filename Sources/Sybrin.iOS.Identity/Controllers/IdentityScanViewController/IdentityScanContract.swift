//
//  IdentityScanContract.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2022/10/26.
//  Copyright © 2022 Sybrin Systems. All rights reserved.
//

import Foundation

enum IdentityScanContract {
    
    enum Action: Equatable {
        case viewWillAppear
        case viewDidLoad
    }
    
    enum Update: Equatable {
        case viewWillAppearUpdate
        case viewDidLoadUpdate
    }
}

protocol IIdentityScanPresenter {
    func perform(_ action: IdentityScanContract.Action)
}

protocol IIdentityScanView {
    func perform(_ update: IdentityScanContract.Update)
}
