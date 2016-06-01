//
//  Validator.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public protocol Validator {
    associatedtype T
    
    func isValid(value: T) throws -> Bool
}