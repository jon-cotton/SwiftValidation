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