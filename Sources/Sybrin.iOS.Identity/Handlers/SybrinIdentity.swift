//
//  SybrinIdentity.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/21.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

@objc public final class SybrinIdentity: NSObject {
    
    // MARK: Private Properties
    private final var SybrinStoryboard: UIStoryboard?
    private final var SybrinLogo: UIImage?
    
    private var executionStart: DispatchTime?
    
    private final var Configuration: SybrinIdentityConfiguration?
    
    private final var InitializedResult: Result<Bool, SybrinError>?
    private final var CurrentlyScanning: (type: DocumentType, country: Country)?
    
    // Scan Document Return Channels
    private final var DocumentSuccessCallback: documentSuccessCallbackType?
    private final var DocumentFailureCallback: failureCallbackType?
    private final var DocumentCancelCallback: cancelCallbackType?
    
    // Scan Drivers License Return Channels
    private final var DriversLicenseSuccessCallback: driversLicenseSuccessCallbackType?
    private final var DriversLicenseFailureCallback: failureCallbackType?
    private final var DriversLicenseCancelCallback: cancelCallbackType?
    
    // Scan Green Book Return Channels
    private final var GreenBookSuccessCallback: greenBookSuccessCallbackType?
    private final var GreenBookFailureCallback: failureCallbackType?
    private final var GreenBookCancelCallback: cancelCallbackType?
    
    // Scan ID Card Return Channels
    private final var IDCardSuccessCallback: idCardSuccessCallbackType?
    private final var IDCardFailureCallback: failureCallbackType?
    private final var IDCardCancelCallback: cancelCallbackType?
    
    // Scan Passport Return Channels
    private final var PassportSuccessCallback: passportSuccessCallbackType?
    private final var PassportFailureCallback: failureCallbackType?
    private final var PassportCancelCallback: cancelCallbackType?
    
    // MARK: Internal Properties
    final let LicenseHandlerObj: LicenseHandler = LicenseHandler()
    final var EnvironmentObj: Environment?
    
    // MARK: Public Properties
    @objc public static let shared: SybrinIdentity = SybrinIdentity()
    @objc public final var configuration: SybrinIdentityConfiguration? { get { return Configuration }
        set {
            if newValue != nil && InitializedResult == nil {
                Configuration = newValue
                EnvironmentObj = DecryptEnvironment(key: newValue!.environmentKey)
                Initialize()
            } else if InitializedResult != nil {
                "Configuration is already initialized".log(.Error)
            }
        }
    }
    
    // Type Aliases
    public typealias doneLaunchingType = (Bool, String?) -> Void
    public typealias failureCallbackType = (String) -> Void
    public typealias cancelCallbackType = () -> Void
    public typealias documentSuccessCallbackType = (DocumentModel) -> Void
    public typealias greenBookSuccessCallbackType = (GreenBookModel) -> Void
    public typealias idCardSuccessCallbackType = (IDCardModel) -> Void
    public typealias passportSuccessCallbackType = (PassportModel) -> Void
    public typealias driversLicenseSuccessCallbackType = (DriversLicenseModel) -> Void
    
    // MARK: Initializers
    private override init() { }
    
    // MARK: Public Methods
    @objc public final func changeLogLevel(to logLevel: LogLevel) {
        LogHandler.globalLogLevel = logLevel
    }
    
    // MARK: Document Scanning
    @objc public final func scanDocument(on viewController: UIViewController, for document: Document,
                                         cutOutType: CutOutType = .DEFAULT, hasBackSide: HasBackSide = .DEFAULT,
                                             doneLaunching: doneLaunchingType? = nil, success: documentSuccessCallbackType? = nil, failure: failureCallbackType? = nil, cancel: cancelCallbackType? = nil) {
        
        executionStart = DispatchTime.now()
        
        
        if case .failure(let error) = PrepareToScan(on: viewController, for: document.documentType, in: document.country) {
            if doneLaunching != nil {
                doneLaunching!(false, error.message)
            }
            return
        }
        
        guard let sybrinStoryboard = SybrinStoryboard else {
            if doneLaunching != nil {
                doneLaunching!(false, SybrinError.SybrinStoryboardNotFound.message)
            }
            return
        }
        
        guard let envObject = EnvironmentObj else {
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        guard let orc_url = envObject.orchestrationURL else {
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        if (orc_url.isEmpty == true || orc_url == ""){
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        if let sybrinVC = sybrinStoryboard.instantiateViewController(withIdentifier: "IdentityScanVC") as? IdentityScanViewController {
            let plan = document.scanPlan(on: sybrinVC, cutOutTpe: cutOutType, hasBackSide: hasBackSide)
            
            self.DocumentSuccessCallback = success
            self.DocumentFailureCallback = failure
            self.DocumentCancelCallback = cancel
            sybrinVC.Plan = plan
            sybrinVC.Delegate = self
            
            viewController.present(sybrinVC, animated: true) { [weak self] in
                guard let self = self else { return }
                
                self.CurrentlyScanning = (type: document.documentType, country: document.country)
                if doneLaunching != nil {
                    doneLaunching!(true, nil)
                }
            }
        } else {
            if doneLaunching != nil {
                doneLaunching!(false, SybrinError.SybrinViewControllerNotFound.message)
            }
        }
    }
    
    // MARK: Drivers License Scanning
    @objc public final func scanDriversLicense(on viewController: UIViewController, for country: Country, cutOutType: CutOutType = .DEFAULT, hasBackSide:HasBackSide = .DEFAULT, doneLaunching: doneLaunchingType? = nil, success: driversLicenseSuccessCallbackType? = nil, failure: failureCallbackType? = nil, cancel: cancelCallbackType? = nil) {
        
        executionStart = DispatchTime.now()
        
        if case .failure(let error) = PrepareToScan(on: viewController, for: .DriversLicense, in: country) {
            if doneLaunching != nil {
                doneLaunching!(false, error.message)
            }
            return
        }
        
        guard let sybrinStoryboard = SybrinStoryboard else {
            if doneLaunching != nil {
                doneLaunching!(false, SybrinError.SybrinStoryboardNotFound.message)
            }
            return
        }
        
        guard let envObject = EnvironmentObj else {
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        guard let orc_url = envObject.orchestrationURL else {
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        if (orc_url.isEmpty == true || orc_url == ""){
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        if let sybrinVC = UINib(nibName: "IdentityScanVC", bundle: nil).instantiate(withOwner: nil, options: nil).first as? IdentityScanViewController {
    
            guard let plan = country.driversLicenseScanPlan(on: sybrinVC) else {
                if let doneLaunching = doneLaunching {
                    doneLaunching(false, SybrinError.InternalError.message)
                }
                return
            }
            
            self.DriversLicenseSuccessCallback = success
            self.DriversLicenseFailureCallback = failure
            self.DriversLicenseCancelCallback = cancel
            sybrinVC.Plan = plan
            sybrinVC.Delegate = self
            
            viewController.present(sybrinVC, animated: true) { [weak self] in
                guard let self = self else { return }
                
                self.CurrentlyScanning = (type: .DriversLicense, country: country)
                
                if let doneLaunching = doneLaunching {
                    doneLaunching(true, nil)
                }
            }
        } else {
            if doneLaunching != nil {
                doneLaunching!(false, SybrinError.SybrinViewControllerNotFound.message)
            }
        }
    }
    
    // MARK: Green Book Scanning
    @objc public final func scanGreenBook(on viewController: UIViewController, doneLaunching: doneLaunchingType? = nil, success: greenBookSuccessCallbackType? = nil, failure: failureCallbackType? = nil, cancel: cancelCallbackType? = nil) {
        
        executionStart = DispatchTime.now()
        
        if case .failure(let error) = PrepareToScan(on: viewController, for: .GreenBook, in: .SouthAfrica) {
            if doneLaunching != nil {
                doneLaunching!(false, error.message)
            }
            return
        }
        
        guard let sybrinStoryboard = SybrinStoryboard else {
            if doneLaunching != nil {
                doneLaunching!(false, SybrinError.SybrinStoryboardNotFound.message)
            }
            return
        }
        
        if let sybrinVC = sybrinStoryboard.instantiateViewController(withIdentifier: "IdentityScanVC") as? IdentityScanViewController {
            guard let plan = Country.SouthAfrica.greenBookScanPlan(on: sybrinVC) else {
                if doneLaunching != nil {
                    doneLaunching!(false,  SybrinError.InternalError.message)
                }
                return
            }
            self.GreenBookSuccessCallback = success
            self.GreenBookFailureCallback = failure
            self.GreenBookCancelCallback = cancel
            sybrinVC.Plan = plan
            sybrinVC.Delegate = self
            
            viewController.present(sybrinVC, animated: true) { [weak self] in
                guard let self = self else { return }
                
                self.CurrentlyScanning = (type: .GreenBook, country: .SouthAfrica)
                if doneLaunching != nil {
                    doneLaunching!(true, nil)
                }
            }
        } else {
            if doneLaunching != nil {
                doneLaunching!(false, SybrinError.SybrinViewControllerNotFound.message)
            }
        }
    }
    
    // MARK: ID Card Scanning
    @objc public final func scanIDCard(on viewController: UIViewController, for country: Country, doneLaunching: doneLaunchingType? = nil, success: idCardSuccessCallbackType? = nil, failure: failureCallbackType? = nil, cancel: cancelCallbackType? = nil) {
        
        executionStart = DispatchTime.now()
        
        if case .failure(let error) = PrepareToScan(on: viewController, for: .IDCard, in: country) {
            if doneLaunching != nil {
                doneLaunching!(false, error.message)
            }
            return
        }
        
        guard let sybrinStoryboard = SybrinStoryboard else {
            if doneLaunching != nil {
                doneLaunching!(false, SybrinError.SybrinStoryboardNotFound.message)
            }
            return
        }
        
        guard let envObject = EnvironmentObj else {
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        guard let orc_url = envObject.orchestrationURL else {
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        if (orc_url.isEmpty == true || orc_url == ""){
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        if let sybrinVC = sybrinStoryboard.instantiateViewController(withIdentifier: "IdentityScanVC") as? IdentityScanViewController {
            guard let plan = country.idCardScanPlan(on: sybrinVC) else {
                if doneLaunching != nil {
                    doneLaunching!(false,  SybrinError.InternalError.message)
                }
                return
            }
            
            self.IDCardSuccessCallback = success
            self.IDCardFailureCallback = failure
            self.IDCardCancelCallback = cancel
            sybrinVC.Plan = plan
            sybrinVC.Delegate = self
            
            viewController.present(sybrinVC, animated: true) { [weak self] in
                guard let self = self else { return }
                
                self.CurrentlyScanning = (type: .IDCard, country: country)
                if doneLaunching != nil {
                    doneLaunching!(true, nil)
                }
            }
        } else {
            if doneLaunching != nil {
                doneLaunching!(false, SybrinError.SybrinViewControllerNotFound.message)
            }
        }
    }
    
    // MARK: Passport Scanning
    @objc public final func scanPassport(on viewController: UIViewController, for country: Country, doneLaunching: doneLaunchingType? = nil, success: passportSuccessCallbackType? = nil, failure: failureCallbackType? = nil, cancel: cancelCallbackType? = nil) {
        
        executionStart = DispatchTime.now()
        
        if case .failure(let error) = PrepareToScan(on: viewController, for: .Passport, in: country) {
            if doneLaunching != nil {
                doneLaunching!(false, error.message)
            }
            return
        }
        
        guard let sybrinStoryboard = SybrinStoryboard else {
            if doneLaunching != nil {
                doneLaunching!(false, SybrinError.SybrinStoryboardNotFound.message)
            }
            return
        }
        
        guard let envObject = EnvironmentObj else {
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        guard let orc_url = envObject.orchestrationURL else {
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        if (orc_url.isEmpty == true || orc_url == ""){
            if doneLaunching != nil {
                doneLaunching!(false, "Invalid enviroment key")
            }
            return
        }
        
        if let sybrinVC = sybrinStoryboard.instantiateViewController(withIdentifier: "IdentityScanVC") as? IdentityScanViewController {
            guard let plan = country.passportScanPlan(on: sybrinVC) else {
                if doneLaunching != nil {
                    doneLaunching!(false,  SybrinError.InternalError.message)
                }
                return
            }
            
            self.PassportSuccessCallback = success
            self.PassportFailureCallback = failure
            self.PassportCancelCallback = cancel
            sybrinVC.Plan = plan
            sybrinVC.Delegate = self
            
            viewController.present(sybrinVC, animated: true) { [weak self] in
                guard let self = self else { return }
                
                self.CurrentlyScanning = (type: .Passport, country: country)
                if doneLaunching != nil {
                    doneLaunching!(true, nil)
                }
            }
        } else {
            if doneLaunching != nil {
                doneLaunching!(false, SybrinError.SybrinViewControllerNotFound.message)
            }
        }
    }
    
    // MARK: Private Methods
    private func DecryptEnvironment(key: String) -> Environment? {
        
        "Decrypting Environment key".log(.Debug)
        let aes = AES(appID: "Environment")
        let jsonString = aes.Decrypt(message: key)
        
        guard jsonString != nil, let jsonData = jsonString?.data(using: .utf8) else {
            "Invalid Environment key".log(.Error)
            return nil
        }
        
        "Environment key decrypted".log(.Debug)
        
        do {
            
            let env = try JSONDecoder().decode(Environment.self, from: jsonData)
            
         
            if (env.orchestrationURL != nil) {
                Constants.orchestrationURL = env.orchestrationURL
            }
            
            if (env.orchestrationAPIKey != nil) {
                Constants.orchestrationAPIKey = env.orchestrationAPIKey
            }
            return env
        } catch {
            "Failed to decode JSON to environment model".log(.ProtectedError)
            "Error: \(error.localizedDescription)".log(.Verbose)
            return nil
        }
        
    }
    
    private final func PrepareToScan(on viewController: UIViewController? = nil, for documentType: DocumentType, in country: Country) -> Result<Bool, SybrinError> {
        guard Configuration != nil else {
            "Configuration not set".log(.Error)
            return .failure(.ConfigurationNotSet)
        }
        
        guard CurrentlyScanning == nil else {
            "Scanning is already in progress".log(.Error)
            return .failure(.ScanInProgress)
        }
        
        if InitializedResult == nil {
            Initialize()
        }
        
        guard case .success(_) = InitializedResult else { return InitializedResult ?? .failure(.InternalError) }
        
        "Validating license".log(.Debug)
        if case .failure(let reason) = LicenseHandlerObj.validateLicense() {
            "License validation failed".log(.Error)
            "Error: \(reason.message)".log(.Verbose)
            if let viewController = viewController, configuration?.displayToastMessages ?? SybrinIdentityConfiguration.DisplayToastMessages {
                viewController.showToast(message: reason.message)
            }
            return .failure(.Licensing(error: reason))
        }
        
        "Checking if country is supported".log(.Debug)
        if !country.supportedDocuments.contains(documentType) {
            "Country not supported".log(.Error)
            return .failure(.CountryNotSupported)
        }
        
        if let viewController = viewController {
            "Checking for camera access".log(.Debug)
            
            var permissionGranted = false
            AccessHandler.checkCameraAccess { granted -> Void in
                
                if !granted {
                    AccessHandler.showUIAlertForCameraPermission(viewController) {
                        permissionGranted = false
                    }
                } else {
                    permissionGranted = true
                }
            }
            
            if permissionGranted {
                return .success(true)
            } else {
                return .failure(.CameraAccessDenied)
            }
            
        } else {
            return .success(true)
        }
        
    }
    
    private func Initialize() {
        "Initializing Identity".log(.Debug)
        
        guard let licenseKey = configuration?.License else {
            "Configuration not set".log(.Error)
            InitializedResult = .failure(.ConfigurationNotSet)
            return
        }
        
        "Setting common settings".log(.Debug)
        SetCommonSettings()
        
        if !LicenseHandlerObj.initialized {
            "Initializing license".log(.Debug)
            if case .failure(let error) = LicenseHandlerObj.initialize(with: licenseKey) {
                "Failed to initialize license".log(.Error)
                "Error: \(error.message)".log(.Verbose)
                InitializedResult = .failure(.Licensing(error: error))
                return
            }
        }
        
        "Setting common configuration".log(.Debug)
        CommonHelper.executeWithDeveloperAccess { [weak self] in
            guard let self = self else { return }
            
            FrameworkConfiguration.configuration = self.configuration
        }
        
        "Loading framework bundle".log(.Debug)
        // if let urlString = UIStoryboard(name: "SybrinIdentity", bundle: Bundle.module) {
        //     let bundle = Bundle(url: NSURL(fileURLWithPath: urlString) as URL)
        //     SybrinStoryboard = UIStoryboard(name: "SybrinIdentity", bundle: bundle)
        //     SybrinLogo = UIImage(named: "SybrinLogoH", in: bundle, compatibleWith: nil)
        // }
        let sybrinStoryboard = UIStoryboard(name: "SybrinIdentity", bundle: Bundle.module)
        "\(sybrinStoryboard)".log(.Debug)

        // Accessing the image from the Swift Package
        let sybrinLogo = UIImage(named: "SybrinLogoH", in: Bundle.module, compatibleWith: nil)
        
        "Setting storyboard".log(.Debug)
        guard SybrinStoryboard != nil else {
            "Failed to set storyboard".log(.ProtectedError)
            InitializedResult = .failure(.SybrinStoryboardNotFound)
            return
        }
        
        "Checking SDK Type".log(.Debug)
        guard LicenseHandlerObj.sdkType != nil, LicenseHandlerObj.sdkType! == .Identity else {
            "Incorrect Framework SDK Type".log(.ProtectedError)
            InitializedResult = .failure(.InternalError)
            return
        }
        
        "Identity initialized".log(.Debug)
        InitializedResult = .success(true)
    }
    
    private func Reset() {
        DocumentSuccessCallback = nil
        DocumentFailureCallback = nil
        DocumentCancelCallback = nil
        
        DriversLicenseSuccessCallback = nil
        DriversLicenseFailureCallback = nil
        DriversLicenseCancelCallback = nil
        
        GreenBookSuccessCallback = nil
        GreenBookFailureCallback = nil
        GreenBookCancelCallback = nil
        
        IDCardSuccessCallback = nil
        IDCardFailureCallback = nil
        IDCardCancelCallback = nil
        
        PassportSuccessCallback = nil
        PassportFailureCallback = nil
        PassportCancelCallback = nil
        
        CurrentlyScanning = nil
    }
    
    private func SetCommonSettings() {
        CommonHelper.executeWithDeveloperAccess { [weak self] in
            guard let self = self else { return }
            
            self.LicenseHandlerObj.sdkType = .Identity
#if DEBUG
            LogHandler.globalLogLevel = .Verbose
            LogHandler.logDebugInformation = true
#endif
        }
    }
    
}

// MARK: Extensions
extension SybrinIdentity: HandleIdentityResponse {
    
    func handleResponse<T>(_ response: T) {
        if let currentScan = CurrentlyScanning {
            
            if NetworkHandler.shared.isConnectedToNetwork(){
                
                guard let executionStart = self.executionStart else{
                    return
                }
                
                let correlationID = SybrinIdentity.shared.Configuration?.correlationID
                
                let executionTime = (DispatchTime.now().uptimeNanoseconds - executionStart.uptimeNanoseconds) / 1_000_000
                
                NetworkCallHandler.PostAuditData(correlationID: correlationID, successfulScan: true, feature: "\(currentScan.country.fullName) \(currentScan.type.stringValue)", featureResult: "\(currentScan.country.fullName) \(currentScan.type.stringValue) scan successful", featureFailureReason: "", executionTimeMillis: executionTime, completion: { (result) in
                    
                    switch result {
                    case .success( _):
                            "Audit posted successfully".log(.ProtectedError)
                        case .failure( _):
                            "Failure posting Audit".log(.ProtectedError)
                    }
                })
            }
            
            if case .failure(let error) = LicenseHandlerObj.updateCount(f: "\(currentScan.country.fullName) \(currentScan.type.stringValue)") {
                
                "Updating count failed".log(.ProtectedError)
                "Error: \(error.message)".log(.Verbose)
            }
            
            switch currentScan.type {
                case .DriversLicense:
                    if response is DriversLicenseModel {
                        guard let response = response as? DriversLicenseModel else { return }
                        
                        DriversLicenseSuccessCallback?(response)
                    }
                case .IDCard:
                    if response is IDCardModel {
                        guard let response = response as? IDCardModel else { return }
                        
                        IDCardSuccessCallback?(response)
                    }
                case .Passport:
                    if response is PassportModel {
                        guard let response = response as? PassportModel else { return }
                        
                        PassportSuccessCallback?(response)
                    }
                case .GreenBook:
                    if response is GreenBookModel {
                        guard let response = response as? GreenBookModel else { return }
                        
                        GreenBookSuccessCallback?(response)
                    }
                default: break
            }
            
            if let response = response as? DocumentModel {
                DocumentSuccessCallback?(response)
            }
            
            Reset()
            
        }
    }
    
    func handleFailure(reason: String) {
        if let currentScan = CurrentlyScanning {
            
            if NetworkHandler.shared.isConnectedToNetwork(){
                
                guard let executionStart = self.executionStart else{
                    return
                }
                
                let correlationID = SybrinIdentity.shared.Configuration?.correlationID
                
                let executionTime = (DispatchTime.now().uptimeNanoseconds - executionStart.uptimeNanoseconds) / 1_000_000
                
                NetworkCallHandler.PostAuditData(correlationID: correlationID, successfulScan: false ,feature: "\(currentScan.country.fullName) \(currentScan.type.stringValue)", featureResult: "", featureFailureReason: reason, executionTimeMillis: executionTime, completion: { (result) in
                    
                    switch result {
                        case .success( _):
                            "Audit posted successfully".log(.ProtectedError)
                        case .failure( _):
                            "Failure posting Audit".log(.ProtectedError)
                    }
                })
            }
            
            switch currentScan.type {
                case .DriversLicense: DriversLicenseFailureCallback?(reason)
                case .IDCard: IDCardFailureCallback?(reason)
                case .Passport: PassportFailureCallback?(reason)
                case .GreenBook: GreenBookFailureCallback?(reason)
                default: break
            }
            
            DocumentFailureCallback?(reason)
            
            Reset()
            
        }
    }
    
    func handleCancel() {
        if let currentScan = CurrentlyScanning {
            
            switch currentScan.type {
                case .DriversLicense: DriversLicenseCancelCallback?()
                case .IDCard: IDCardCancelCallback?()
                case .Passport: PassportCancelCallback?()
                case .GreenBook: GreenBookCancelCallback?()
                default: break
            }
            
            DocumentCancelCallback?()
            
            Reset()
            
        }
    }
    
}
