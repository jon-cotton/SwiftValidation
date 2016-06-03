//
//  ComparableValidationError.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public enum ComparableValidationError<T>: ErrorType {
    case valueIsBelowMinimumBounds(T)
    case valueIsAboveMaximumBounds(T)
}