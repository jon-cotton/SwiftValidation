//
//  Validateable.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public protocol Validateable {
    associatedtype ValidatorType: Validator
    
    func validValue(validators: ValidatorType...) throws -> ValidatorType.T
}

extension Validateable where ValidatorType.T == Self {
    func validValue(validators: [ValidatorType]) throws -> Self {
        var errors = AggregateError()
        
        for validator in validators {
            do {
                try validator.isValid(self)
            } catch {
                errors.addError(error)
            }
        }
        
        guard errors.isEmpty else {
            throw errors
        }
        
        return self
    }
    
    func validValue(validators: ValidatorType...) throws -> Self {
        return try validValue(validators)
    }
}

extension Optional where Wrapped: Validateable, Wrapped.ValidatorType.T == Wrapped {
    func validValue(validators: [Wrapped.ValidatorType]) throws -> Wrapped {
        switch self {
        case .None:
            throw ValidationError.valueIsNil
            
        case .Some(let value):
            return try value.validValue(validators)
        }
    }
    
    func validValue(validators: Wrapped.ValidatorType...) throws -> Wrapped {
        return try validValue(validators)
    }
}
