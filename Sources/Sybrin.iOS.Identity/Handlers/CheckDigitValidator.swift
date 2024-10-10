//
//  CheckDigitValidator.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

struct CheckDigitValidator {
    
    // MARK: Internal Methods
    static func GetCheckDigitUsingMRZAlgorithm(for value: String) -> Int {
        let weightRecursArray = [7, 3, 1]
        var weightRecursIndex = 0
        let elementPoints = ["<": 0, "0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "A": 10, "B": 11, "C": 12, "D": 13, "E": 14, "F": 15, "G": 16, "H": 17, "I": 18, "J": 19, "K": 20, "L": 21, "M": 22, "N": 23, "O": 24, "P": 25, "Q": 26, "R": 27, "S": 28, "T": 29, "U": 30, "V": 31, "W": 32, "X": 33, "Y": 34, "Z": 35]
        var productSum = 0
        
        for char in value {
            productSum += (elementPoints[String(char)] ?? 0) * weightRecursArray[weightRecursIndex]
            weightRecursIndex += 1
            if (weightRecursIndex >= weightRecursArray.count) {
                weightRecursIndex = 0
            }
        }
        
        return productSum % 10
    }
    
    static func GetCheckDigitUsingLuhnAlgorithm(for value: String) -> Int {
        var index = value.count - 1 // starting from the last character in the string
        var productSum = 0
        for char in value.reversed() {
            var charNumber = Int(String(char)) ?? 0
            if index % 2 == 1 { // if the index is odd then it means that the actual character "index" is even i.e. the 12th character is even but it's index (11) is odd.
                if (charNumber >= 5) {
                    charNumber = (charNumber * 2) - 9
                }
                else {
                    charNumber = charNumber * 2
                }
            }
            
            if (index + 1 < value.count) {
                productSum += charNumber
            }
            
            index -= 1
        }
        
        return (productSum * 9) % 10
    }
    
}
