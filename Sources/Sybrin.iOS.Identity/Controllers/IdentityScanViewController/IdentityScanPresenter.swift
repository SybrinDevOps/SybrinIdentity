//
//  IdentityScanPresenter.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2022/10/26.
//  Copyright © 2022 Sybrin Systems. All rights reserved.
//

import Foundation

class IdentityScanPresenter: IIdentityScanPresenter {
    
    var view: IIdentityScanView
    
    init (view: IIdentityScanView) {
        self.view = view
    }
    
    func perform(_ action: IdentityScanContract.Action) {
        switch action {
        case .viewDidLoad:
            break
        case .viewWillAppear:
            view.perform(.viewWillAppearUpdate)
        }
    }
}
