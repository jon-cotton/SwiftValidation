//
//  ComparableValidator.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public enum ComparableValidator<T: Comparable>: Validator {
    case minimumValue(T)
    case maximumValue(T)
    case range(T, T)
    
    public func isValid(value: T) throws -> Bool {
        var min: T?
        var max: T?
        
        switch self {
        case .minimumValue(let inMin):
            min = inMin
            
        case .maximumValue(let inMax):
            max = inMax
            
        case .range(let inMin, let inMax):
            min = inMin
            max = inMax
            
            guard min < max else {
                throw ComparableValidationError<T>.lowerBoundsMustBeLessThanUpperBounds
            }
        }
        
        if let min = min {
            guard value >= min else {
                throw ComparableValidationError.valueIsBelowMinimumBounds(min)
            }
        }
        
        if let max = max {
            guard value <= max else {
                throw ComparableValidationError.valueIsAboveMaximumBounds(max)
            }
        }
        
        return true
    }
}

extension Int: Validateable {
    public typealias ValidatorType = ComparableValidator<Int>
}

extension Double: Validateable {
    public typealias ValidatorType = ComparableValidator<Double>
}

extension Float: Validateable {
    public typealias ValidatorType = ComparableValidator<Float>
}