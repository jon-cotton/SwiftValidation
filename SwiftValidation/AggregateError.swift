//
//  AggregateError.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

struct AggregateError: ErrorType {
    private(set) var errors: [ErrorType] = []
    
    mutating func addError(error: ErrorType) {
        errors.append(error)
    }
    
    var isEmpty: Bool {
        return errors.isEmpty
    }
}

extension AggregateError: CollectionType {
    typealias Index = Int
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return errors.count
    }
    
    subscript(i: Int) -> ErrorType {
        return errors[i]
    }
}
