//
//  MRVBModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/11.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//
import Foundation

final class MRVBModel {
    
    // MARK: Internal Properties
    // MRZ Lines
    final var MRZLine1: String?
    final var MRZLine2: String?
    
    // MRZ Line 1
    final var DocumentType: String?
    final var IssuingCountryCode: String?
    final var Surname: String?
    final var Names: String?
    
    // MRZ Line 2
    final var DocumentNumber: String?
    final var DocumentNumberCheckDigit: Int?
    final var NationalityCountryCode: String?
    final var DateOfBirth: Date?
    final var DateOfBirthCheckDigit: Int?
    final var Sex: Sex?
    final var DateOfExpiry: Date?
    final var DateOfExpiryCheckDigit: Int?
    final var OptionalData: String?
}
