//
//  Date.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/05/01.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
import Foundation

extension Date {

    var isRealisticBirthDate: Bool {
        guard let minBirthDate = Calendar.current.date(byAdding: Calendar.Component.year, value: -110, to: Date()) else { return false }
        return self < Date() && self > minBirthDate
    }
    
}
