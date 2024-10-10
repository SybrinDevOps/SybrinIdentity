//
//  Document.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/03/19.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//
import Foundation

@objc public enum Document: Int, CaseIterable {
//    case AngolaPassport
//    case BangladeshPassport
//    case BotswanaPassport
//    case DemocraticRepublicOfTheCongoPassport
//    case EgyptPassport
//    case EthiopiaPassport
    case GenericDocument
//    case GenericIDCard
//    case GenericPassport
//    case GhanaPassport
//    case KenyaIDCard
//    case KenyaPassport
//    case LesothoPassport
//    case MalawiPassport
//    case MauritiusPassport
//    case MozambiqueIDCard
//    case MozambiquePassport
//    case NamibiaPassport
//    case NigeriaPassport
//    case PakistanPassport
    case PhilippinesDriversLicense
    case PhilippinesFirearmsLicense
    case PhilippinesIntegratedBarID
    case PhilippinesPassport
    case PhilippinesPhilHealthInsuranceCard
    case PhilippinesPostalID
    case PhilippinesProfessionalRegulationCommissionCard
    case PhilippinesSeafarerIdentificationDocument
    case PhilippinesSeafarerIdentificationRecordBook
    case PhilippinesSocialSecurityID
    case PhilippinesUnifiedMultipurposeID
    case PhilippinesIdentificationCard
    case PhilippinesQCIdentificationCard
//    case SomaliaPassport
//    case SouthAfricaDriversLicense
//    case SouthAfricaGeneralWorkVisa
    case SouthAfricaGreenBook
    case SouthAfricaIDCard
    case SouthAfricaPassport
//    case SouthAfricaRetiredPersonVisa
//    case SouthAfricaStudyPermit
//    case SouthAfricaStudyVisa
//    case SouthAfricaVisitorVisa
//    case TanzaniaPassport
//    case UgandaIDCard
//    case UgandaPassport
//    case UnitedKingdomPassport
//    case ZambiaPassport
//    case ZimbabwePassport
    
    
    public var name: String {
        switch self {
//            case .AngolaPassport: return "Angola Passport"
//            case .BangladeshPassport: return "Bangladesh Passport"
//            case .BotswanaPassport: return "Botswana Passport"
//            case .DemocraticRepublicOfTheCongoPassport: return "Democractic Republic of the Congo Passport"
//            case .EgyptPassport: return "Egypt Passport"
//            case .EthiopiaPassport: return "Ethipia Passport"
//            case .GenericIDCard: return "Generic ID Card"
            case.GenericDocument: return "Generic Document"
//            case .GenericPassport: return "Generic Passport"
//            case .GhanaPassport: return "Ghana Passport"
//            case .KenyaIDCard: return "Kenya ID Card"
//            case .KenyaPassport: return "Kenya Passport"
//            case .LesothoPassport: return "Lesotho Passport"
//            case .MalawiPassport: return "Malawi Passport"
//            case .MauritiusPassport: return "Mauritius Passport"
//            case .MozambiqueIDCard: return "Mozambique ID Card"
//            case .MozambiquePassport: return "Mozambique Passport"
//            case .NamibiaPassport: return "Namibia Passport"
//            case .NigeriaPassport: return "Nigeria Passport"
//            case .PakistanPassport: return "Pakistan Passport"
            case .PhilippinesDriversLicense: return "Philippines Driver's License"
            case .PhilippinesFirearmsLicense: return "Philippines Firearms License"
            case .PhilippinesIntegratedBarID: return "Philippines Integrated Bar ID"
            case .PhilippinesPassport: return "Philippines Passport"
            case .PhilippinesPhilHealthInsuranceCard: return "Philippines Phil Health Insurance Card"
            case .PhilippinesPostalID: return "Philippines Postal ID"
            case .PhilippinesProfessionalRegulationCommissionCard: return "Philippines Professional Regulation Commission Card"
            case .PhilippinesSeafarerIdentificationDocument: return "Philippines Seafarer Identification Document"
            case .PhilippinesSeafarerIdentificationRecordBook: return "Philippines Seaferer Identitfication Record Book"
            case .PhilippinesSocialSecurityID: return "Philippines Social Security ID"
            case .PhilippinesUnifiedMultipurposeID: return "Philippines Unified Multipurpose ID"
            case .PhilippinesIdentificationCard: return "Philippines Identification Card"
            case .PhilippinesQCIdentificationCard: return "Philippines QC Identification Card"
//            case .SomaliaPassport: return "Somalia Passport"
//            case .SouthAfricaDriversLicense: return "South Africa Driver's License"
//            case .SouthAfricaGeneralWorkVisa: return "South Africa General Work Visa"
            case .SouthAfricaGreenBook: return "South Africa GreenBook"
            case .SouthAfricaIDCard: return "South Africa ID Card"
            case .SouthAfricaPassport: return "South Africa Passport"
//            case .SouthAfricaRetiredPersonVisa: return "South Africa Retired Person Visa"
//            case .SouthAfricaStudyPermit: return "South Africa Study Permit"
//            case .SouthAfricaStudyVisa: return "South Africa Study Visa"
//            case .SouthAfricaVisitorVisa: return "South Africa Visitor Visa"
//            case .TanzaniaPassport: return "Tanzania Passport"
//            case .UgandaIDCard: return "Uganda ID Card"
//            case .UgandaPassport: return "Uganda Passport"
//            case .UnitedKingdomPassport: return "United Kingdom Passport"
//            case .ZambiaPassport: return "Zambia Passport"
//            case .ZimbabwePassport: return "Zimbabwe Passport"
        }
    }
    
    public var country: Country {
        switch self {
//            case .AngolaPassport: return Country.Angola
//            case .BangladeshPassport: return Country.Bangladesh
//            case .BotswanaPassport: return Country.Botswana
//            case .DemocraticRepublicOfTheCongoPassport: return Country.DemocraticRepublicOfTheCongo
//            case .EgyptPassport: return Country.Egypt
//            case .EthiopiaPassport: return Country.Ethiopia
            case .GenericDocument: return Country.Generic
//            case .GenericIDCard: return Country.Generic
//            case .GenericPassport: return Country.Generic
//            case .GhanaPassport: return Country.Ghana
//            case .KenyaIDCard: return Country.Kenya
//            case .KenyaPassport: return Country.Kenya
//            case .LesothoPassport: return Country.Lesotho
//            case .MalawiPassport: return Country.Malawi
//            case .MauritiusPassport: return Country.Mauritius
//            case .MozambiqueIDCard: return Country.Mozambique
//            case .MozambiquePassport: return Country.Mozambique
//            case .NamibiaPassport: return Country.Namibia
//            case .NigeriaPassport: return Country.Nigeria
//            case .PakistanPassport: return Country.Pakistan
            case .PhilippinesDriversLicense: return Country.Philippines
            case .PhilippinesFirearmsLicense: return Country.Philippines
            case .PhilippinesIntegratedBarID: return Country.Philippines
            case .PhilippinesPassport: return Country.Philippines
            case .PhilippinesPhilHealthInsuranceCard: return Country.Philippines
            case .PhilippinesPostalID: return Country.Philippines
            case .PhilippinesProfessionalRegulationCommissionCard: return Country.Philippines
            case .PhilippinesSeafarerIdentificationDocument: return Country.Philippines
            case .PhilippinesSeafarerIdentificationRecordBook: return Country.Philippines
            case .PhilippinesSocialSecurityID: return Country.Philippines
            case .PhilippinesUnifiedMultipurposeID: return Country.Philippines
            case .PhilippinesIdentificationCard: return Country.Philippines
            case .PhilippinesQCIdentificationCard: return Country.Philippines
//            case .SomaliaPassport: return Country.Somalia
//            case .SouthAfricaDriversLicense: return Country.SouthAfrica
//            case .SouthAfricaGeneralWorkVisa: return Country.SouthAfrica
            case .SouthAfricaGreenBook: return Country.SouthAfrica
            case .SouthAfricaIDCard: return Country.SouthAfrica
            case .SouthAfricaPassport: return Country.SouthAfrica
//            case .SouthAfricaRetiredPersonVisa: return Country.SouthAfrica
//            case .SouthAfricaStudyPermit: return Country.SouthAfrica
//            case .SouthAfricaStudyVisa: return Country.SouthAfrica
//            case .SouthAfricaVisitorVisa: return Country.SouthAfrica
//            case .TanzaniaPassport: return Country.Tanzania
//            case .UgandaIDCard: return Country.Uganda
//            case .UgandaPassport: return Country.Uganda
//            case .UnitedKingdomPassport: return Country.UnitedKingdom
//            case .ZambiaPassport: return Country.Zambia
//            case .ZimbabwePassport: return Country.Zimbabwe
        }
    }
    
    public var documentType: DocumentType {
        switch self {
//            case .AngolaPassport: return DocumentType.Passport
//            case .BangladeshPassport: return DocumentType.Passport
//            case .BotswanaPassport: return DocumentType.Passport
//            case .DemocraticRepublicOfTheCongoPassport: return DocumentType.Passport
//            case .EgyptPassport: return DocumentType.Passport
//            case .EthiopiaPassport: return DocumentType.Passport
//            case .GenericIDCard: return DocumentType.IDCard
            case .GenericDocument: return DocumentType.Document
//            case .GenericPassport: return DocumentType.Passport
//            case .GhanaPassport: return DocumentType.Passport
//            case .KenyaIDCard: return DocumentType.IDCard
//            case .KenyaPassport: return DocumentType.Passport
//            case .LesothoPassport: return DocumentType.Passport
//            case .MalawiPassport: return DocumentType.Passport
//            case .MauritiusPassport: return DocumentType.Passport
//            case .MozambiqueIDCard: return DocumentType.IDCard
//            case .MozambiquePassport: return DocumentType.Passport
//            case .NamibiaPassport: return DocumentType.Passport
//            case .NigeriaPassport: return DocumentType.Passport
//            case .PakistanPassport: return DocumentType.Passport
            case .PhilippinesDriversLicense: return DocumentType.DriversLicense
            case .PhilippinesFirearmsLicense: return DocumentType.FirearmsLicense
            case .PhilippinesIntegratedBarID: return DocumentType.IntegratedBarID
            case .PhilippinesPassport: return DocumentType.Passport
            case .PhilippinesPhilHealthInsuranceCard: return DocumentType.PhilHealthInsuranceCard
            case .PhilippinesPostalID: return DocumentType.PostalID
            case .PhilippinesProfessionalRegulationCommissionCard: return DocumentType.ProfessionalRegulationCommissionCard
            case .PhilippinesSeafarerIdentificationDocument: return DocumentType.SeafarerIdentificationDocument
            case .PhilippinesSeafarerIdentificationRecordBook: return DocumentType.SeafarerIdentificationRecordBook
            case .PhilippinesSocialSecurityID: return DocumentType.SocialSecurityID
            case .PhilippinesUnifiedMultipurposeID: return DocumentType.UnifiedMultipurposeID
            case .PhilippinesIdentificationCard: return DocumentType.SeafarerIdentificationDocument //DocumentType.IDCard
            case .PhilippinesQCIdentificationCard: return DocumentType.QCIdentificationCard
//            case .SomaliaPassport: return DocumentType.Passport
//            case .SouthAfricaDriversLicense: return DocumentType.DriversLicense
//            case .SouthAfricaGeneralWorkVisa: return DocumentType.Visa
            case .SouthAfricaGreenBook: return DocumentType.GreenBook
            case .SouthAfricaIDCard: return DocumentType.IDCard
            case .SouthAfricaPassport: return DocumentType.Passport
//            case .SouthAfricaRetiredPersonVisa: return DocumentType.Visa
//            case .SouthAfricaStudyPermit: return DocumentType.Visa
//            case .SouthAfricaStudyVisa: return DocumentType.Visa
//            case .SouthAfricaVisitorVisa: return DocumentType.Visa
//            case .TanzaniaPassport: return DocumentType.Passport
//            case .UgandaIDCard: return DocumentType.IDCard
//            case .UgandaPassport: return DocumentType.Passport
//            case .UnitedKingdomPassport: return DocumentType.Passport
//            case .ZambiaPassport: return DocumentType.Passport
//            case .ZimbabwePassport: return DocumentType.Passport
        }
    }
    
    // MARK: Internal Scan Plans
    func scanPlan(on viewController: ScanViewController, cutOutTpe: CutOutType = .DEFAULT, hasBackSide: HasBackSide = .DEFAULT) -> ScanPlan<DocumentModel> {
        switch self {
//            case .AngolaPassport: return AngolaPassportScanPlan(name: name, controller: viewController)
//            case .BangladeshPassport: return BangladeshPassportScanPlan(name: name, controller: viewController)
//            case .BotswanaPassport: return BotswanaPassportScanPlan(name: name, controller: viewController)
//            case .DemocraticRepublicOfTheCongoPassport: return DemocraticRepublicOfTheCongoPassportScanPlan(name: name, controller: viewController)
//            case .EgyptPassport: return EgyptPassportScanPlan(name: name, controller: viewController)
//            case .EthiopiaPassport: return EthiopiaPassportScanPlan(name: name, controller: viewController)
        case .GenericDocument: return GenericDocunentScanPlan(name: name, controller: viewController, cutOutType: cutOutTpe)
//            case .GenericIDCard: return GenericIDCardScanPlan(name: name, controller: viewController)
//            case .GenericPassport: return GenericPassportScanPlan(name: name, controller: viewController)
//            case .GhanaPassport: return GhanaPassportScanPlan(name: name, controller: viewController)
//            case .KenyaIDCard: return KenyaIDCardScanPlan(name: name, controller: viewController)
//            case .KenyaPassport: return KenyaPassportScanPlan(name: name, controller: viewController)
//            case .LesothoPassport: return LesothoPassportScanPlan(name: name, controller: viewController)
//            case .MalawiPassport: return MalawiPassportScanPlan(name: name, controller: viewController)
//            case .MauritiusPassport: return MauritiusPassportScanPlan(name: name, controller: viewController)
//            case .MozambiqueIDCard: return MozambiqueIDCardScanPlan(name: name, controller: viewController)
//            case .MozambiquePassport: return MozambiquePassportScanPlan(name: name, controller: viewController)
//            case .NamibiaPassport: return NamibiaPassportScanPlan(name: name, controller: viewController)
//            case .NigeriaPassport: return NigeriaPassportScanPlan(name: name, controller: viewController)
//            case .PakistanPassport: return PakistanPassportScanPlan(name: name, controller: viewController)
        case .PhilippinesDriversLicense: return PhilippinesDriversLicenseScanPlan(name: name, controller: viewController, cutOutType: cutOutTpe, hasBackSide: hasBackSide)
            case .PhilippinesFirearmsLicense: return PhilippinesFirearmsLicenseScanPlan(name: name, controller: viewController)
            case .PhilippinesIntegratedBarID: return PhilippinesIntegratedBarIDScanPlan(name: name, controller: viewController)
            case .PhilippinesPassport: return PhilippinesPassportScanPlan(name: name, controller: viewController)
            case .PhilippinesQCIdentificationCard: return PhilippinesQCIdentificationCardScanPlan(name: name, controller: viewController)
            case .PhilippinesPhilHealthInsuranceCard: return PhilippinesPhilHealthInsuranceCardScanPlan(name: name, controller: viewController)
            case .PhilippinesPostalID: return PhilippinesPostalIDScanPlan(name: name, controller: viewController)
            case .PhilippinesProfessionalRegulationCommissionCard: return PhilippinesProfessionalRegulationCommissionCardScanPlan(name: name, controller: viewController)
            case .PhilippinesSeafarerIdentificationDocument: return PhilippinesSeafarerIdentificationDocumentScanPlan(name: name, controller: viewController)
            case .PhilippinesSeafarerIdentificationRecordBook: return PhilippinesSeafarerIdentificationRecordBookScanPlan(name: name, controller: viewController)
            case .PhilippinesSocialSecurityID: return PhilippinesSocialSecurityIDScanPlan(name: name, controller: viewController)
            case .PhilippinesUnifiedMultipurposeID: return PhilippinesUnifiedMultipurposeIDScanPlan(name: name, controller: viewController)
            case .PhilippinesIdentificationCard: return PhilippinesIdentificationCardScanPlan(name: name, controller: viewController)
//            case .SomaliaPassport: return SomaliaPassportScanPlan(name: name, controller: viewController)
//            case .SouthAfricaDriversLicense: return SouthAfricaDriversLicenseScanPlan(name: name, controller: viewController)
//            case .SouthAfricaGeneralWorkVisa: return SouthAfricaGeneralWorkVisaScanPlan(name: name, controller: viewController)
            case .SouthAfricaGreenBook: return SouthAfricaGreenBookScanPlan(name: name, controller: viewController)
            case .SouthAfricaIDCard: return SouthAfricaIDCardScanPlan(name: name, controller: viewController)
            case .SouthAfricaPassport: return SouthAfricaPassportScanPlan(name: name, controller: viewController)
//            case .SouthAfricaRetiredPersonVisa: return SouthAfricaRetiredPersonVisaScanPlan(name: name, controller: viewController)
//            case .SouthAfricaStudyPermit: return SouthAfricaStudyPermitScanPlan(name: name, controller: viewController)
//            case .SouthAfricaStudyVisa: return SouthAfricaStudyVisaScanPlan(name: name, controller: viewController)
//            case .SouthAfricaVisitorVisa: return SouthAfricaVisitorVisaScanPlan(name: name, controller: viewController)
//            case .TanzaniaPassport: return TanzaniaPassportScanPlan(name: name, controller: viewController)
//            case .UgandaIDCard: return UgandaIDCardScanPlan(name: name, controller: viewController)
//            case .UgandaPassport: return UgandaPassportScanPlan(name: name, controller: viewController)
//            case .UnitedKingdomPassport: return UnitedKingdomPassportScanPlan(name: name, controller: viewController)
//            case .ZambiaPassport: return ZambiaPassportScanPlan(name: name, controller: viewController)
//            case .ZimbabwePassport: return ZimbabwePassportScanPlan(name: name, controller: viewController)
        
        }
    }
    
}
