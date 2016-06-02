//
//  RegexPatternTests.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import XCTest
@testable import SwiftValidation

class RegexPatternTests: XCTestCase {
    func test_string_literal_can_be_used_as_regex_pattern() {
        guard (try? Regex("^*$")) != nil else {
            XCTFail("Expected Regex init to succeed with valid regex pattern from String")
            return
        }
    }
    
    func test_string_based_enum_can_be_used_as_regex_pattern() {
        enum pattern: String, RegexPattern {
            case everything = "^*$"
        }
        
        guard (try? Regex(pattern.everything)) != nil else {
            XCTFail("Expected Regex init to succeed with valid regex pattern from RawRepresentible String")
            return
        }
    }
    
    func test_regex_pattern_match_returns_true_when_supplied_string_matches_pattern() {
        guard let didMatch = try? "^*$".match("abc123") else {
            XCTFail("Expected Regex init to succeed with valid regex pattern from String")
            return
        }
        
        XCTAssertTrue(didMatch)
    }
    
    func test_regex_pattern_match_throws_error_when_supplied_string_does_not_match_pattern() {
       XCTAssertThrowsError(try "^[a-z]*$".match("123"))
    }

    func test_regex_pattern_match_throws_regex_error_when_supplied_string_does_not_match_pattern_and_no_other_error_has_been_supplied() {
        do {
            try "^[a-z]*$".match("123")
        } catch let regexError as RegexError {
            XCTAssertEqual(regexError, RegexError.stringDoesNotMatchRegexPattern)
        } catch {
            XCTFail("Regex match failure threw unexpected error type")
        }
    }
    
    func test_regex_pattern_match_throws_error_to_throw_on_failure_when_supplied_string_does_not_match_pattern() {
        enum MockRegexError: ErrorType {
            case alphaPatternDidNotMatch
        }
        
        enum pattern: String, RegexPattern {
            case alpha = "^[a-zA-z]*$"
            
            var errorToThrowOnFailure: ErrorType? {
                return MockRegexError.alphaPatternDidNotMatch
            }
        }
        
        do {
            try pattern.alpha.match("123")
        } catch let customError as MockRegexError {
            XCTAssertEqual(customError, MockRegexError.alphaPatternDidNotMatch)
        } catch {
            XCTFail("Regex match failure did not throw error from errorToThrowOnFailure property")
        }
    }
}
