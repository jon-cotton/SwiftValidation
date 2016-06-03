//
//  ComparableValidatorTests.swift
//  SwiftValidation
//
//  Created by Jon on 02/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import XCTest
@testable import SwiftValidation

class ComparableValidatorTests: XCTestCase {

    func test_comparable_validator_is_valid_returns_true_for_value_higher_than_minimum_bounds_when_testing_for_minimum_value() {
        let comparableValidator = ComparableValidator.minimumValue(10)
        
        guard let result = try? comparableValidator.isValid(20) else {
            XCTFail("Expected minimum value test to pass when testing higher value than minimum bounds")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_comparable_validator_is_valid_returns_true_for_value_equal_to_minimum_bounds_when_testing_for_minimum_value() {
        let comparableValidator = ComparableValidator.minimumValue(10)
        
        guard let result = try? comparableValidator.isValid(10) else {
            XCTFail("Expected minimum value test to pass when testing equal value to minimum bounds")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_comparable_validator_throws_is_below_minimum_bounds_error_for_value_below_minimum_bounds_when_testing_for_minimum_value() {
        let comparableValidator = ComparableValidator.minimumValue(10)
        
        XCTAssertThrowsError(try comparableValidator.isValid(5)) { error in
            guard let comparableValidationError = error as? ComparableValidationError<Int> else {
                XCTFail("Unexpected error type thrown by ComparableValidator on failure")
                return
            }
            
            switch comparableValidationError {
            case .valueIsBelowMinimumBounds(let min):
                XCTAssertEqual(min, 10)
            default:
                XCTFail("Unexpected ComparableValidationError type thrown by ComparableValidator on failure")
            }
        }
    }
    
    func test_comparable_validator_is_valid_returns_true_for_value_lower_than_maximum_bounds_when_testing_for_maximum_value() {
        let comparableValidator = ComparableValidator.maximumValue(10)
        
        guard let result = try? comparableValidator.isValid(5) else {
            XCTFail("Expected maximum value test to pass when testing higher value than maximum bounds")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_comparable_validator_is_valid_returns_true_for_value_equal_to_maximum_bounds_when_testing_for_maximum_value() {
        let comparableValidator = ComparableValidator.maximumValue(10)
        
        guard let result = try? comparableValidator.isValid(10) else {
            XCTFail("Expected maximum value test to pass when testing equal value to maximum bounds")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_comparable_validator_throws_is_above_maximum_bounds_error_for_value_above_maximum_bounds_when_testing_for_maximum_value() {
        let comparableValidator = ComparableValidator.maximumValue(10)
        
        XCTAssertThrowsError(try comparableValidator.isValid(20)) { error in
            guard let comparableValidationError = error as? ComparableValidationError<Int> else {
                XCTFail("Unexpected error type thrown by ComparableValidator on failure")
                return
            }
            
            switch comparableValidationError {
            case .valueIsAboveMaximumBounds(let max):
                XCTAssertEqual(max, 10)
            default:
                XCTFail("Unexpected ComparableValidationError type thrown by ComparableValidator on failure")
            }
        }
    }
    
    func test_comparable_validator_is_valid_returns_true_for_value_within_supplied_range_when_testing_for_value_within_range() {
        let comparableValidator = ComparableValidator.range(10, 20)
        
        guard let result = try? comparableValidator.isValid(15) else {
            XCTFail("Expected value in range test to pass when testing value within bounds")
            return
        }
        
        XCTAssertTrue(result)
    }
    
}
