//
//  RegexTests.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import XCTest
@testable import SwiftValidation

class RegexTests: XCTestCase {
    func test_regex_fails_to_initialise_with_invalid_pattern() {
        XCTAssertThrowsError(try Regex(""))
    }
    
    func test_regex_test_returns_true_when_string_matches_supplied_pattern() {
        guard let regex = try? Regex("^*$") else {
            XCTFail("Regex failed to initialise with valid regex pattern")
            return
        }
        
        XCTAssertTrue(regex.test("abc123"))
    }

    func test_regex_test_returns_false_when_string_does_not_match_supplied_pattern() {
        guard let regex = try? Regex("^[a-z]*$") else {
            XCTFail("Regex failed to initialise with valid regex pattern")
            return
        }
        
        XCTAssertFalse(regex.test("abc123"))
    }
}
