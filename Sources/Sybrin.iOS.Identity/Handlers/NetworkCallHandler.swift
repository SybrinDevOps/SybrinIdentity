//
//  CorrelationIDCallHandler.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/10/20.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Foundation
import UIKit
import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

class NetworkCallHandler{
    
    static func PostAuditData(correlationID: String?, successfulScan: Bool, feature: String, featureResult: String, featureFailureReason: String, executionTimeMillis: UInt64, phoneModel: String = UIDevice.modelName, osVersion: String = UIDevice.current.systemVersion, completion: @escaping(Result<Bool, IdentityNetworkError>) -> Void) {
        
        guard let urlString = SybrinIdentity.shared.EnvironmentObj?.AuditingURL else{
            return
        }
        
        guard !urlString.isEmpty else{
            return
        }

//        "https://jnb-inn-app.sybrin.co.za/Auditing/Auditing/Save"
        
        guard let endpoint: URL = URL(string: urlString) else {
            completion(.failure(.NetworkError(error: .BadRequest)))
            return
        }
        
        var request: URLRequest = URLRequest(url: endpoint)
        
        request.httpMethod = "POST"
        
        if let authToken = SybrinIdentity.shared.configuration?.customAuthorizationToken {
            request.addValue(authToken, forHTTPHeaderField: "Authorization")
        }
//        request.addValue(correlationID, forHTTPHeaderField: "CorrelationID")
        request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        let Body: [String: Any?] = [
            "ObjectID": "SybrinIdentitySDKAuditingModel",
            "CorrelationID": correlationID,
            "SuccessfulScan": successfulScan,
            "Feature": feature,
            "FeatureResult": featureResult,
            "FeatureFailureReason": featureFailureReason,
            "ExecutionTimeMillis": executionTimeMillis,
            "PhoneModel": phoneModel,
            "OSVersion": osVersion,
            "Platform": "iOS"
        ]
        
        do {
        request.httpBody = try JSONSerialization.data(withJSONObject: Body, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        NetworkHandler.shared.sendRequest(request: request) { (result) in
            switch result {
            case .success((let data, let response)):
                
                guard let responseStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                    "Received an unknown response code".log(.ProtectedError)
                    completion(.failure(.NetworkError(error: .IncorrectResponseCode)))
                    return
                }
                
                guard responseStatusCode == 200 else {
                    do {
                        "Received an invalid (not 200) response code".log(.ProtectedError)
                        "Response Code: \(responseStatusCode)".log(.Verbose)
                        if let rawResponse = String(data: data, encoding: .utf8) {
                            "Raw Response: \(rawResponse)".log(.Verbose)
                            
                            completion(.failure(.Error(message: "Error: Response Code: \(responseStatusCode)", details: "Response code not 200")))
                        }
                    }
                    /* catch {
                        "Failed to decode to error object".log(.ProtectedError)
                        "Error: \(error.localizedDescription)".log(.Verbose)
                        completion(.failure(.NetworkError(error: .IncorrectResponseCode)))
                    } */
                    
                    completion(.success(true))
                    return
                }
                
            case .failure(let error):
                completion(.failure(.NetworkError(error: error)))
            }
        }
        } catch {
            "Request body parse error".log(.ProtectedError)
            "Error: \(error.localizedDescription)".log(.Verbose)
            completion(.failure(.NetworkError(error: .BadRequest)))
        }
    }
    
}
