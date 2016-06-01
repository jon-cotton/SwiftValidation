//
//  RegexPattern.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

protocol RegexPattern {
    var pattern: String {get}
    var errorToThrow: ErrorType {get}
    
    func match(string: String) throws -> Bool
}

extension RegexPattern {
    func match(string: String) throws -> Bool {
        guard string =~ pattern else {
            throw errorToThrow
        }
        
        return true
    }
}

extension String: RegexPattern {
    var pattern: String {
        return self
    }
    
    var errorToThrow: ErrorType {
        return RegexError.stringDoesNotMatchRegexPattern
    }
}

extension RegexPattern where Self: RawRepresentable, Self.RawValue == String {
    var pattern: String {
        return rawValue
    }
}
