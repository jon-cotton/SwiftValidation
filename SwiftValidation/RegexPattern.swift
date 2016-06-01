//
//  RegexPattern.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public protocol RegexPattern {
    var pattern: String {get}
    var errorToThrowOnFailure: ErrorType? {get}
    
    func match(string: String) throws -> Bool
}

public extension RegexPattern {
    func match(string: String) throws -> Bool {
        guard string =~ pattern else {
            throw errorToThrowOnFailure ?? RegexError.stringDoesNotMatchRegexPattern
        }
        
        return true
    }
    
    public var errorToThrowOnFailure: ErrorType? {
        return nil
    }
}

extension String: RegexPattern {
    public var pattern: String {
        return self
    }
}

public extension RegexPattern where Self: RawRepresentable, Self.RawValue == String {
    var pattern: String {
        return rawValue
    }
}
