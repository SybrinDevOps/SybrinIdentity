//
//  PassData.swift
//  Sybrin.iOS.Identity.Showcase
//
//  Created by Nico Celliers on 2020/09/01.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

//import Sybrin_iOS_Identity

//import Sybrin_iOS_Identity

public protocol PassData {
    func handleGreenBookData(_ data: GreenBookModel)
    func handleIDCardData(_ data: IDCardModel)
    func handlePassportData(_ data: PassportModel)
}
