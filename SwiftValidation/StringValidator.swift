//
//  StringValidator.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public enum StringValidator: Validator {
    case nonEmpty
    case regex(RegexPattern)
    case match(String)
    case minimumLength(Int)
    case maximumLength(Int)
    case lengthWithinRange(Int, Int)
    
    public func isValid(value: String) throws -> Bool {
        let string = value
        var minLength: Int?
        var maxLength: Int?
        
        switch self {
        case .nonEmpty:
            guard string != "" else {
                throw StringValidationError.stringIsEmpty
            }
            
        case .regex(let pattern):
            try pattern.match(string)
            
        case .match(let toMatch):
            guard string == toMatch else {
                throw StringValidationError.stringsDoNotMatch
            }
            
        case .minimumLength(let min):
            minLength = min
            
        case .maximumLength(let max):
            maxLength = max
            
        case .lengthWithinRange(let min, let max):
            minLength = min
            maxLength = max
            
        }
        
        if let minLength = minLength {
            guard string.characters.count >= minLength else {
                throw StringValidationError.stringIsShorterThanAllowedMinimumLength(minLength)
            }
        }
        
        if let maxLength = maxLength {
            guard string.characters.count <= maxLength else {
                throw StringValidationError.stringIsLongerThanAllowedMaximumLength(maxLength)
            }
        }
        
        return true
    }
}