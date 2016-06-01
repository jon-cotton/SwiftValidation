//
//  Regex.swift
//  SwiftValidation
//
//  Created by Jon on 01/06/2016.
//  Copyright © 2016 joncotton. All rights reserved.
//

import Foundation

public struct Regex {
    let expression: NSRegularExpression
    
    init(_ pattern: RegexPattern) throws {
        expression = try NSRegularExpression(pattern: pattern.pattern, options: .DotMatchesLineSeparators)
    }
    
    func test(string: String) -> Bool {
        let matches = expression.matchesInString(string, options: .ReportCompletion, range: NSMakeRange(0, string.characters.count))
        return matches.count > 0
    }
}

infix operator =~ {}
func =~ (input: String, pattern: RegexPattern) -> Bool {
    do {
        return try Regex(pattern).test(input)
    } catch {
        return false
    }
}