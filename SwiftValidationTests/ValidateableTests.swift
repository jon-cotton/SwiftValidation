//
//  ValidateableTests.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import XCTest
@testable import SwiftValidation

class ValidateableTests: XCTestCase {
    enum MockValidationError: ErrorType {
        case failed
    }
    
    struct MockValidator: Validator {
        var shouldPass = true
        
        func isValid(value: MockValidateable) throws -> Bool {
            guard shouldPass else {
                throw MockValidationError.failed
            }
            
            return true
        }
    }
    
    class MockValidateable: Validateable {
        typealias ValidatorType = MockValidator
    }
    
    func test_validateable_valid_value_returns_itself_when_the_validator_passes() {
        let mockValidateable = MockValidateable()
        var mockValidator = MockValidator()
        mockValidator.shouldPass = true
        
        guard let validValue = try? mockValidateable.validValue(mockValidator) else {
            XCTFail("Expected Validateable to return itself from validValue")
            return
        }
        
        XCTAssert(validValue === mockValidateable)
    }
    
    func test_validateable_valid_value_throws_an_error_when_the_validator_fails() {
        let mockValidateable = MockValidateable()
        var mockValidator = MockValidator()
        mockValidator.shouldPass = false
        
        XCTAssertThrowsError(try mockValidateable.validValue(mockValidator))
    }
    
    func test_validateable_valid_value_throws_a_nil_error_if_testing_a_nil_optional() {
        let mockValidateable: MockValidateable? = nil
        var mockValidator = MockValidator()
        mockValidator.shouldPass = true
        
        do {
            try mockValidateable.validValue(mockValidator)
        } catch let validationError as ValidationError {
            XCTAssertEqual(validationError, ValidationError.valueIsNil)
        } catch {
            XCTFail("Validateable validValue threw unexpected error when testing nil optional")
        }
        
        XCTAssertThrowsError(try mockValidateable.validValue(mockValidator))
    }
    
    func test_validateable_valid_value_returns_unwrapped_value_when_testing_non_nil_optional() {
        let mockValidateable: MockValidateable? = MockValidateable()
        var mockValidator = MockValidator()
        mockValidator.shouldPass = true
        
        guard let validValue = try? mockValidateable.validValue(mockValidator) else {
            XCTFail("Expected Validateable to return unwrapped self from validValue")
            return
        }
        
        XCTAssert(validValue === mockValidateable)
    }

}
