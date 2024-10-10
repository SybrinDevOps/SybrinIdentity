//
//  Environment.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/10/20.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Foundation

public struct Environment: Codable {
    
    // MARK: Public Properties
    public var AuditingURL: String?
    public var orchestrationURL: String?
    public var orchestrationAPIKey: String?
    
    // MARK: Initializers
    public init() { }
    
}
