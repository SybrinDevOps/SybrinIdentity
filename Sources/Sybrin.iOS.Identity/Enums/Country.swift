//
//  Country.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/21.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

@objc public enum Country: Int, CaseIterable {
    case Angola
    case Bangladesh
    case Botswana
    case DemocraticRepublicOfTheCongo
    case Egypt
    case Ethiopia
    case Generic
    case Ghana
    case Kenya
    case Lesotho
    case Malawi
    case Mauritius
    case Mozambique
    case Namibia
    case Nigeria
    case Pakistan
    case Philippines
    case Somalia
    case SouthAfrica
    case Tanzania
    case Uganda
    case UnitedKingdom
    case Zambia
    case Zimbabwe
    
    public var fullName: String {
        switch self {
            case .Angola: return "Angola"
            case .Bangladesh: return "Bangladesh"
            case .Botswana: return "Botswana"
            case .DemocraticRepublicOfTheCongo: return "Democratic Republic of the Congo"
            case .Egypt: return "Egypt"
            case .Ethiopia: return "Ethiopia"
            case .Generic: return "Generic"
            case .Ghana: return "Ghana"
            case .Kenya: return "Kenya"
            case .Lesotho: return "Lesotho"
            case .Malawi: return "Malawi"
            case .Mauritius: return "Mauritius"
            case .Mozambique: return "Mozambique"
            case .Namibia: return "Namibia"
            case .Nigeria: return "Nigeria"
            case .Pakistan: return "Pakistan"
            case .Philippines: return "Philippines"
            case .Somalia: return "Somalia"
            case .SouthAfrica: return "South Africa"
            case .Tanzania: return "Tanzania"
            case .Uganda: return "Uganda"
            case .UnitedKingdom: return "United Kingdom"
            case .Zambia: return "Zambia"
            case .Zimbabwe: return "Zimbabwe"
        }
    }
    
    public var idCardCountryCode: String {
        switch self {
            case .Angola: return "AGO"
            case .Bangladesh: return "BGD"
            case .Botswana: return "BWA"
            case .DemocraticRepublicOfTheCongo: return "COD"
            case .Egypt: return "EGY"
            case .Ethiopia: return "ETH"
            case .Generic: return ""
            case .Ghana: return "GHA"
            case .Kenya: return "KYA"
            case .Lesotho: return "LSO"
            case .Malawi: return "MWI"
            case .Mauritius: return "MUS"
            case .Mozambique: return "MOZ"
            case .Namibia: return "NAM"
            case .Nigeria: return "NGA"
            case .Pakistan: return "PAK"
            case .Philippines: return "PHL"
            case .Somalia: return "SOM"
            case .SouthAfrica: return "RSA"
            case .Tanzania: return "TZA"
            case .Uganda: return "UGA"
            case .UnitedKingdom: return "GBR"
            case .Zambia: return "ZMB"
            case .Zimbabwe: return "ZIM"
        }
    }
    
    public var passportCountryCode: String {
        switch self {
            case .Angola: return "AGO"
            case .Bangladesh: return "BGD"
            case .Botswana: return "BWA"
            case .DemocraticRepublicOfTheCongo: return "COD"
            case .Egypt: return "EGY"
            case .Ethiopia: return "ETH"
            case .Generic: return ""
            case .Ghana: return "GHA"
            case .Kenya: return "KEN"
            case .Lesotho: return "LSO"
            case .Malawi: return "MWI"
            case .Mauritius: return "MUS"
            case .Mozambique: return "MOZ"
            case .Namibia: return "NAM"
            case .Nigeria: return "NGA"
            case .Pakistan: return "PAK"
            case .Philippines: return "PHL"
            case .Somalia: return "SOM"
            case .SouthAfrica: return "ZAF"
            case .Tanzania: return "TZA"
            case .Uganda: return "UGA"
            case .UnitedKingdom: return "GBR"
            case .Zambia: return "ZMB"
            case .Zimbabwe: return "ZWE"
        }
    }
    
    public var isoCode: String {
        switch self {
            case .Angola: return "AO"
            case .Bangladesh: return "BD"
            case .Botswana: return "BW"
            case .DemocraticRepublicOfTheCongo: return "CD"
            case .Egypt: return "EG"
            case .Ethiopia: return "ET"
            case .Generic: return ""
            case .Ghana: return "GH"
            case .Kenya: return "KE"
            case .Lesotho: return "LS"
            case .Malawi: return "MW"
            case .Mauritius: return "MU"
            case .Mozambique: return "MZ"
            case .Namibia: return "NA"
            case .Nigeria: return "NG"
            case .Pakistan: return "PK"
            case .Philippines: return "PH"
            case .Somalia: return "SO"
            case .SouthAfrica: return "ZA"
            case .Tanzania: return "TZ"
            case .Uganda: return "UG"
            case .UnitedKingdom: return "GB"
            case .Zambia: return "ZM"
            case .Zimbabwe: return "ZW"
        }
    }
    
    public var supportedDocuments: [DocumentType] {
        switch self {
            case .Angola: return [.Passport]
            case .Bangladesh: return [.Passport]
            case .Botswana: return [.Passport]
            case .DemocraticRepublicOfTheCongo: return [.Passport]
            case .Egypt: return [.Passport]
            case .Ethiopia: return [.Passport]
            case .Generic: return [.Passport, .Document, .IDCard]
            case .Ghana: return [.Passport]
            case .Kenya: return [.IDCard, .Passport]
            case .Lesotho: return [.Passport]
            case .Malawi: return [.Passport]
            case .Mauritius: return [.Passport]
            case .Mozambique: return [.IDCard, .Passport]
            case .Namibia: return [.Passport]
            case .Nigeria: return [.Passport]
            case .Pakistan: return [.Passport]
        case .Philippines: return [.DriversLicense, .FirearmsLicense, .IntegratedBarID, .Passport, .PhilHealthInsuranceCard, .PostalID, .ProfessionalRegulationCommissionCard, .SeafarerIdentificationDocument, .SeafarerIdentificationRecordBook, .SocialSecurityID, .UnifiedMultipurposeID, .IDCard, .QCIdentificationCard]
            case .Somalia: return [.Passport]
            case .SouthAfrica: return [.DriversLicense, .IDCard, .GreenBook, .Passport, .Visa]
            case .Tanzania: return [.Passport]
            case .Uganda: return [.IDCard, .Passport]
            case .UnitedKingdom: return [.Passport]
            case .Zambia: return [.Passport]
            case .Zimbabwe: return [.Passport]
        }
    }
    
    // MARK: Internal Scan Plans
    func driversLicenseScanPlan(on viewController: ScanViewController) -> ScanPlan<DocumentModel>? {
        switch self {
            case .Philippines: return Document.PhilippinesDriversLicense.scanPlan(on: viewController)
//            case .SouthAfrica: return Document.SouthAfricaDriversLicense.scanPlan(on: viewController)
            default: return nil
        }
    }
    
    func greenBookScanPlan(on viewController: ScanViewController) -> ScanPlan<DocumentModel>? {
        switch self {
            case .SouthAfrica: return Document.SouthAfricaGreenBook.scanPlan(on: viewController)
            default: return nil
        }
    }
    
    func idCardScanPlan(on viewController: ScanViewController) -> ScanPlan<DocumentModel>? {
        switch self {
//            case .Kenya: return Document.KenyaIDCard.scanPlan(on: viewController)
//            case .Mozambique: return Document.MozambiqueIDCard.scanPlan(on: viewController)
            case .SouthAfrica: return Document.SouthAfricaIDCard.scanPlan(on: viewController)
//            case .Uganda: return Document.UgandaIDCard.scanPlan(on: viewController)
        case .Philippines: return Document.PhilippinesIdentificationCard.scanPlan(on: viewController)
            default: return nil
        }
    }
    
    func passportScanPlan(on viewController: ScanViewController) -> ScanPlan<DocumentModel>? {
        switch self {
//            case .Angola: return Document.AngolaPassport.scanPlan(on: viewController)
//            case .Bangladesh: return Document.BangladeshPassport.scanPlan(on: viewController)
//            case .Botswana: return Document.BotswanaPassport.scanPlan(on: viewController)
//            case .DemocraticRepublicOfTheCongo: return Document.DemocraticRepublicOfTheCongoPassport.scanPlan(on: viewController)
//            case .Egypt: return Document.EgyptPassport.scanPlan(on: viewController)
//            case .Ethiopia: return Document.EthiopiaPassport.scanPlan(on: viewController)
//            case .Generic: return Document.GenericPassport.scanPlan(on: viewController)
//            case .Ghana: return Document.GhanaPassport.scanPlan(on: viewController)
//            case .Kenya: return Document.KenyaPassport.scanPlan(on: viewController)
//            case .Lesotho: return Document.LesothoPassport.scanPlan(on: viewController)
//            case .Malawi: return Document.MalawiPassport.scanPlan(on: viewController)
//            case .Mauritius: return Document.MauritiusPassport.scanPlan(on: viewController)
//            case .Mozambique: return Document.MozambiquePassport.scanPlan(on: viewController)
//            case .Nigeria: return Document.NigeriaPassport.scanPlan(on: viewController)
//            case .Pakistan: return Document.PakistanPassport.scanPlan(on: viewController)
            case .Philippines: return Document.PhilippinesPassport.scanPlan(on: viewController)
//            case .Somalia: return Document.SomaliaPassport.scanPlan(on: viewController)
            case .SouthAfrica: return Document.SouthAfricaPassport.scanPlan(on: viewController)
//            case .Tanzania: return Document.TanzaniaPassport.scanPlan(on: viewController)
//            case .Uganda: return Document.UgandaPassport.scanPlan(on: viewController)
//            case .UnitedKingdom: return Document.UnitedKingdomPassport.scanPlan(on: viewController)
//            case .Zambia: return Document.ZambiaPassport.scanPlan(on: viewController)
//            case .Zimbabwe: return Document.ZimbabwePassport.scanPlan(on: viewController)
            default: return nil
        }
    }
    
}


