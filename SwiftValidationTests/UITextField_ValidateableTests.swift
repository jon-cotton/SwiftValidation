//
//  UITextField_ValidateableTests.swift
//  SwiftValidation
//
//  Created by Jon on 02/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import XCTest
@testable import SwiftValidation

class UITextField_ValidateableTests: XCTestCase {
    func test_valid_value_returns_text_field_contents_when_contents_are_valid() {
        let textField = UITextField()
        textField.text = "non empty string"
        
        guard let validValue = try? textField.validValue(.nonEmpty) else {
            XCTFail("Expected UITextField contents to be valid")
            return
        }
        
        XCTAssertEqual(validValue, "non empty string")
    }
    
    func test_valid_value_throws_validation_user_input_error_when_contents_are_not_valid() {
        let textField = UITextField()
        textField.text = "non matching string"
        
        XCTAssertThrowsError(try textField.validValue(.match("abc"))) { error in
            guard let UIError = error as? ValidationUserInputError else {
                XCTFail("Unexpected error type thrown by UITextField on validation failure")
                return
            }
            
            XCTAssertEqual(UIError.UIElement, textField)
            XCTAssertEqual(UIError.errors.count, 1)
        }
    }
}
