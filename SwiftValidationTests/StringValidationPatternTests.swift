//
//  StringValidationPatternTests.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import XCTest
@testable import SwiftValidation

class StringValidationPatternTests: XCTestCase {

    func test_string_validation_alpha_only_regex_pattern_throws_contains_non_alpha_characters_error_on_failure_to_match() {
        XCTAssertThrowsError(try StringValidationPattern.alphaOnly.match("123")) { error in
            guard let stringValidationError = error as? StringValidationError else {
                XCTFail("Unexpected error type thrown by StringValidationPattern match failure")
                return
            }
            
            switch stringValidationError {
            case .stringContainsNonAlphaCharacters:
                XCTAssert(true)
            default:
                XCTFail("Unexpected StringValidationError type thrown by StringValidationPattern match failure")
            }
        }
    }
    
    func test_string_validation_numeric_only_regex_pattern_throws_contains_non_numeric_characters_error_on_failure_to_match() {
        XCTAssertThrowsError(try StringValidationPattern.numericOnly.match("abc")) { error in
            guard let stringValidationError = error as? StringValidationError else {
                XCTFail("Unexpected error type thrown by StringValidationPattern match failure")
                return
            }
            
            switch stringValidationError {
            case .stringContainsNonNumericCharacters:
                XCTAssert(true)
            default:
                XCTFail("Unexpected StringValidationError type thrown by StringValidationPattern match failure")
            }
        }
    }
    
    func test_string_validation_alpha_numeric_only_regex_pattern_throws_contains_non_alpha_numeric_characters_error_on_failure_to_match() {
        XCTAssertThrowsError(try StringValidationPattern.alphaNumericOnly.match("%$£")) { error in
            guard let stringValidationError = error as? StringValidationError else {
                XCTFail("Unexpected error type thrown by StringValidationPattern match failure")
                return
            }
            
            switch stringValidationError {
            case .stringContainsNonAlphaNumericCharacters:
                XCTAssert(true)
            default:
                XCTFail("Unexpected StringValidationError type thrown by StringValidationPattern match failure")
            }
        }
    }
    
    func test_string_validation_email_regex_pattern_throws_contains_not_a_valid_email_address_error_on_failure_to_match() {
        XCTAssertThrowsError(try StringValidationPattern.email.match("G*b.c")) { error in
            guard let stringValidationError = error as? StringValidationError else {
                XCTFail("Unexpected error type thrown by StringValidationPattern match failure")
                return
            }
            
            switch stringValidationError {
            case .stringIsNotAValidEmailAddress:
                XCTAssert(true)
            default:
                XCTFail("Unexpected StringValidationError type thrown by StringValidationPattern match failure")
            }
        }
    }

}
