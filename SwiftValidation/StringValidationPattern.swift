//
//  StringValidationPattern.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public enum StringValidationPattern: String, RegexPattern {
    case alphaOnly = "^[a-zA-Z]*$"
    case numericOnly = "^[0-9]*$"
    case alphaNumericOnly = "^[a-zA-Z0-9]*$"
    case email = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    public var errorToThrow: ErrorType {
        switch self {
            case .alphaOnly: return StringValidationError.stringContainsNonAlphaCharacters
            case .numericOnly: return StringValidationError.stringContainsNonNumericCharacters
            case .alphaNumericOnly: return StringValidationError.stringContainsNonAlphaNumericCharacters
            case .email: return StringValidationError.stringIsNotAValidEmailAddress
        }
    }
}
