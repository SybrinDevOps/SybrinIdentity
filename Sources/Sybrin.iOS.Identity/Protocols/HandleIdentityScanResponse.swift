//
//  HandleIdentityResponse.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/06.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

protocol HandleIdentityResponse: AnyObject {
    func handleResponse<T>(_ response: T)
    func handleFailure(reason: String)
    func handleCancel()
}
