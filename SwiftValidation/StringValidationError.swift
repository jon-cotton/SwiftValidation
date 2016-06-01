//
//  StringValidationError.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public enum StringValidationError: ErrorType {
    case stringIsEmpty
    case stringContainsNonAlphaCharacters
    case stringContainsNonNumericCharacters
    case stringContainsNonAlphaNumericCharacters
    case stringIsNotAValidEmailAddress
    case stringsDoNotMatch
    case stringIsShorterThanAllowedMinimumLength(Int)
    case stringIsLongerThanAllowedMaximumLength(Int)
    case stringIsNotOneOfAllowedValues([String])
}
