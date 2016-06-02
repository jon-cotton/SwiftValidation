//
//  AggregateErrorTests.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import XCTest
@testable import SwiftValidation

class AggregateErrorTests: XCTestCase {
    class MockError: ErrorType {}
    
    func test_aggregate_error_can_add_new_error() {
        let error = MockError()
        
        var aggregateError = AggregateError()
        aggregateError.addError(error)
        
        guard let firstError = aggregateError[0] as? MockError else {
            XCTFail("Unable to retrieve the error just added")
            return
        }
        
        XCTAssert(firstError === error)
    }
    
    func test_aggregate_error_is_iterable() {
        let errorOne = MockError()
        let errorTwo = MockError()
        let errorThree = MockError()
        
        var aggregateError = AggregateError()
        aggregateError.addError(errorOne)
        aggregateError.addError(errorTwo)
        aggregateError.addError(errorThree)
        
        for (i, error) in aggregateError.enumerate() {
            guard let mockError = error as? MockError else {
                XCTFail("Unexpected error type in AggregateError")
                return
            }
            
            switch i {
            case 0: XCTAssert(mockError === errorOne)
            case 1: XCTAssert(mockError === errorTwo)
            case 2: XCTAssert(mockError === errorThree)
            default: XCTFail("Unexpected number of errors in AggregateError")
            }
        }
    }
    
    func test_aggregate_error_is_empty_returns_true_when_it_contains_no_errors() {
        let aggregateError = AggregateError()
        XCTAssertTrue(aggregateError.isEmpty)
    }
    
    func test_aggregate_error_is_empty_returns_false_when_it_contains_errors() {
        let error = MockError()
        
        var aggregateError = AggregateError()
        aggregateError.addError(error)
        
        XCTAssertFalse(aggregateError.isEmpty)
    }
}
