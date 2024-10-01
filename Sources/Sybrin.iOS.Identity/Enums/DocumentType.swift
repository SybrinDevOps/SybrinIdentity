//
//  DocumentType.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/24.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

@objc public enum DocumentType: Int, CaseIterable {
    // Base
    case Document
    case DriversLicense
    case GreenBook
    case IDCard
    case Passport
    case Visa
    
    // Philippines
    case FirearmsLicense
    case IntegratedBarID
    case PhilHealthInsuranceCard
    case PostalID
    case ProfessionalRegulationCommissionCard
    case SeafarerIdentificationDocument
    case SeafarerIdentificationRecordBook
    case SocialSecurityID
    case UnifiedMultipurposeID
    case QCIdentificationCard
    
    public var stringValue: String {
        switch self {
            // Base
            case .Document: return "Document"
            case .DriversLicense: return "Drivers License"
            case .GreenBook: return "Green Book"
            case .IDCard: return "ID Card"
            case .Passport: return "Passport"
            case .Visa: return "Visa"
                
            // Philippines
            case .FirearmsLicense: return "Firearms License"
            case .IntegratedBarID: return "Integrated Bar ID"
            case .PhilHealthInsuranceCard: return "Phil Health Insurance Card"
            case .PostalID: return "Postal ID"
            case .ProfessionalRegulationCommissionCard: return "Professional Regulation Commission Card"
            case .SeafarerIdentificationDocument: return "Seafarer Identification Document"
            case .SeafarerIdentificationRecordBook: return "Seafarer Identification Record Book"
            case .SocialSecurityID: return "Social Security ID"
            case .UnifiedMultipurposeID: return "Unified Multipurpose ID"
            case .QCIdentificationCard: return "QC Identification Card"
        }
    }
    
}
