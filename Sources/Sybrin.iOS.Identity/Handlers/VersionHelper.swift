//
//  VersionHelper.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/06/04.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common
import Foundation

struct VersionHelper {
    
    static let frameworkBundle = Bundle(for: SybrinIdentity.self)
    static let commonBundle = Bundle(for: CameraHandler.self)
    
    static var frameworkVersion: String? {
        return frameworkBundle.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var frameworkBuild: String? {
        return frameworkBundle.infoDictionary?["CFBundleVersion"] as? String
    }
    
    static var commonVersion: String? {
        return commonBundle.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var commonBuild: String? {
        return commonBundle.infoDictionary?["CFBundleVersion"] as? String
    }
    
    static var frameworkVersionBuild: String? {
        if let frameworkVersion = frameworkVersion, let frameworkBuild = frameworkBuild {
            return "v\(frameworkVersion)b\(frameworkBuild)"
        }
        return nil
    }
    
    static var commonVersionBuild: String? {
        if let commonVersion = commonVersion, let commonBuild = commonBuild {
            return "v\(commonVersion)b\(commonBuild)"
        }
        return nil
    }
    
}
