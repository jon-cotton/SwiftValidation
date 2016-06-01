//
//  ValidationUserInputError.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public struct ValidationUserInputError: ErrorType {
    public let UIElement: UIControl
    public let errors: AggregateError
    
    public init(UIElement: UIControl, errors: AggregateError) {
        self.UIElement = UIElement
        self.errors = errors
    }
}