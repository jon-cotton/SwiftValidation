//
//  StringValidatorTests.swift
//  SwiftValidation
//
//  Created by Jon on 02/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftValidation

class StringValidatorTests: XCTestCase {
    func test_string_validator_is_valid_returns_true_for_non_empty_string_test_when_testing_non_empty_string() {
        let stringValidator = StringValidator.nonEmpty
        
        guard let result = try? stringValidator.isValid("non empty string") else {
            XCTFail("Expected non empty string test to pass with non empty string")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_string_validator_throws_is_empty_error_when_testing_empty_string() {
        let stringValidator = StringValidator.nonEmpty
        
        XCTAssertThrowsError(try stringValidator.isValid("")) { error in
            guard let stringValidationError = error as? StringValidationError else {
                XCTFail("Unexpected error type thrown by StringValidator on failure")
                return
            }
            
            switch stringValidationError {
            case .stringIsEmpty:
                XCTAssert(true)
            default:
                XCTFail("Unexpected StringValidationError type thrown by StringValidator on failure")
            }
        }
    }
    
    func test_string_validator_is_valid_returns_true_for_regex_pattern_test_when_testing_matching_string() {
        let stringValidator = StringValidator.regex("^*$")
        
        guard let result = try? stringValidator.isValid("a string") else {
            XCTFail("Expected regex string test to pass with matching string")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_string_validator_throws_does_not_match_regex_pattern_error_when_testing_non_matching_string() {
        let stringValidator = StringValidator.regex("^a$")
        
        XCTAssertThrowsError(try stringValidator.isValid("b")) { error in
            guard let regexError = error as? RegexError else {
                XCTFail("Unexpected error type thrown by StringValidator on failure")
                return
            }
            
            switch regexError {
            case .stringDoesNotMatchRegexPattern:
                XCTAssert(true)
            }
        }
    }
    
    func test_string_validator_is_valid_returns_true_for_matching_string_test_when_testing_matching_string() {
        let stringValidator = StringValidator.match("a")
        
        guard let result = try? stringValidator.isValid("a") else {
            XCTFail("Expected matching string test to pass with matching string")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_string_validator_throws_does_not_match_error_when_testing_non_matching_strings() {
        let stringValidator = StringValidator.match("a")
        
        XCTAssertThrowsError(try stringValidator.isValid("b")) { error in
            guard let stringValidationError = error as? StringValidationError else {
                XCTFail("Unexpected error type thrown by StringValidator on failure")
                return
            }
            
            switch stringValidationError {
            case .stringsDoNotMatch:
                XCTAssert(true)
            default:
                XCTFail("Unexpected StringValidationError type thrown by StringValidator on failure")
            }
        }
    }
    
    func test_string_validator_is_valid_returns_true_for_minimum_length_test_when_testing_string_longer_than_minimum_length() {
        let stringValidator = StringValidator.minimumLength(5)
        
        guard let result = try? stringValidator.isValid("a long string") else {
            XCTFail("Expected minimum length string test to pass with string longer than minumum length")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_string_validator_throws_is_shorter_than_minimum_length_error_when_testing_string_shorter_than_minimum_length() {
        let stringValidator = StringValidator.minimumLength(5)
        
        XCTAssertThrowsError(try stringValidator.isValid("a")) { error in
            guard let stringValidationError = error as? StringValidationError else {
                XCTFail("Unexpected error type thrown by StringValidator on failure")
                return
            }
            
            switch stringValidationError {
            case .stringIsShorterThanAllowedMinimumLength(let min):
                XCTAssertEqual(min, 5)
            default:
                XCTFail("Unexpected StringValidationError type thrown by StringValidator on failure")
            }
        }
    }
    
    func test_string_validator_is_valid_returns_true_for_maximum_length_test_when_testing_string_shorter_than_maximum_length() {
        let stringValidator = StringValidator.maximumLength(5)
        
        guard let result = try? stringValidator.isValid("a") else {
            XCTFail("Expected maximum length string test to pass with string shorter than maxumum length")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_string_validator_throws_is_longer_than_maximum_length_error_when_testing_string_longer_than_maximum_length() {
        let stringValidator = StringValidator.maximumLength(5)
        
        XCTAssertThrowsError(try stringValidator.isValid("a long string")) { error in
            guard let stringValidationError = error as? StringValidationError else {
                XCTFail("Unexpected error type thrown by StringValidator on failure")
                return
            }
            
            switch stringValidationError {
            case .stringIsLongerThanAllowedMaximumLength(let max):
                XCTAssertEqual(max, 5)
            default:
                XCTFail("Unexpected StringValidationError type thrown by StringValidator on failure")
            }
        }
    }
    
    func test_string_validator_is_valid_returns_true_for_length_within_range_test_when_testing_string_length_is_in_range() {
        let stringValidator = StringValidator.lengthWithinRange(1, 5)
        
        guard let result = try? stringValidator.isValid("abc") else {
            XCTFail("Expected length within range string test to pass with string that is within length range")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_string_validator_is_valid_returns_true_for_one_of_string_test_when_testing_string_contained_within_set() {
        let stringValidator = StringValidator.oneOf(["a", "b", "c"])
        
        guard let result = try? stringValidator.isValid("a") else {
            XCTFail("Expected one of string test to pass with string contained within set")
            return
        }
        
        XCTAssertTrue(result)
    }
    
    func test_string_validator_throws_not_in_allowed_values_error_when_testing_nstring_not_contained_within_set() {
        let stringValidator = StringValidator.oneOf(["a", "b", "c"])
        
        XCTAssertThrowsError(try stringValidator.isValid("x")) { error in
            guard let stringValidationError = error as? StringValidationError else {
                XCTFail("Unexpected error type thrown by StringValidator on failure")
                return
            }
            
            switch stringValidationError {
            case .stringIsNotOneOfAllowedValues(let allowedValues):
                XCTAssertEqual(allowedValues, ["a", "b", "c"])
            default:
                XCTFail("Unexpected StringValidationError type thrown by StringValidator on failure")
            }
        }
    }
    
}
