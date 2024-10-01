//
//  CommonHelper.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/04/14.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_iOS_Common //import Sybrin_iOS_Common //import Sybrin_iOS_Common

struct CommonHelper {
    
    static func executeWithDeveloperAccess(_ perform: @escaping () -> Void) {
        DeveloperSettings.enableDeveloperAccess(token: "zSssBA3k3B7o7aNUSYDnz9BTFmeuVTqVl5KXK6yIbBS3eD3zdyCMMgZ3ozaW4D06fMc4HjOpUew9IV96OxijqyslFtVJI2J7NInG3YySbb9Zao5U3BO597kFlXxMem8hW1CdNJ3tiOYI8E4eXkmhIjREnt1xWAJ7SO5aQwHRTRAV8MEqLjMPvk1J7Cc2wlTQPO78QUNE")
        
        perform()
        
        DeveloperSettings.disableDeveloperAccess()
    }
    
}
