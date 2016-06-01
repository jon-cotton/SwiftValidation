//
//  AggregateError.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public struct AggregateError: ErrorType {
    private var errors: [ErrorType] = []
    
    public mutating func addError(error: ErrorType) {
        errors.append(error)
    }
    
    public var isEmpty: Bool {
        return errors.isEmpty
    }
}

extension AggregateError: CollectionType {
    public typealias Index = Array<ErrorType>.Index
    
    public var startIndex: Index {
        return errors.startIndex
    }
    
    public var endIndex: Index {
        return errors.endIndex
    }
    
    public subscript(i: Index) -> ErrorType {
        return errors[i]
    }
}