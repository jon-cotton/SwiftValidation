# Swift Validation
Simple Validation library for Swift, adds validation directly to built in types String, Int, Double and Float

## Features
Adds the ability to validate String, Int, Double and Float values with basic validation rules out of the box. Also extends UITextField so you can easily test the validity of user input. The two base types `Validator` and `Validateable` are generic enough that they can be easily applied to any type, so you can add a set of validation rules for any custom type you create. Validation failures will throw 'multiple' errors, once for each failure, this allows you to quickly check a whole form of UITextFields for valid user input and report back all errors in a single pass.

## Installation

## Usage
The `Validateable` behaviour is applied directly to the built in `String` type, so to validate the value of a String, you can simply do...
```swift
// The following code prints "stringIsNotAValidEmailAddress" to console
do {
    let validEmailAddress = try "someinvalidemailaddress@invalid>co,uk".validValue(.nonEmpty, .regex(StringValidationPattern.email))
} catch let errors as AggregateError {
    // AggregateError is a collection of ErrorType
    print(errors.reduce("", combine: { "\($0) \($1)" }))
} catch {
    // Some other error occurred
}
```

Validation can also be applied to unwrapped optionals, if the value is nil, an error will be thrown. If the value is valid, the optional will be unwrapped and the value will be returned.
```swift
// The following code prints "valueIsNil" to console
do {
    let goodOptionalString: String? = "Hello!"
    var badOptionalString: String?
    let validUnwrappedString = try goodOptionalString.validValue(.nonEmpty, .minimumLength(5)) // Passes
    let invalidString = try badOptionalString.validValue(.nonEmpty, .minimumLength(5)) // Fails because nil
} catch let errors as AggregateError {
    print(errors.reduce("", combine: { "\($0) \($1)" }))
} catch {
    // Some other error occurred
}
```

To validate the contents of a `UITextField`

```swift
// The following code prints "stringsDoNotMatch stringIsBelowMinimumAllowedLength(12)" to console
let passwordTextField = UITextField()
let passwordConfirmationTextField = UITextField()

/*
User has inputted the following...
Password: "letmein123"
Confirm: "letmein223"
*/

do {
    let passwordConfirmation = try passwordConfirmationTextField.validValue(.nonEmpty)
    let password = try passwordTextField.validValue(.nonEmpty, .minimumLength(12), .match(passwordConfirmation))
} catch let errors as AggregateError {
    print(errors.reduce("", combine: { "\($0) \($1)" }))
} catch {
    // Some other error occurred
}
```

The validValue method which comes as part of `Validateable` expects one or more `Validator` types, the library comes with built in Validators for Strings and `Comparable` types. The supplied list of Validators must all be of the same type.

### StringValidator

The built in `StringValidator` has several basic rules that can be used to build up more complex validation rules, the base set of rules is...

- `.nonEmpty` - The string cannot be empty ("")
- `.regex(RegexPattern)` - The string must match the supplied [RegexPattern](#regexpattern)
- `.match(String)` - The string must be equal to the supplied string
- `.minimumLength(Int)` - The string's length must be greater or equal to the supplied value
- `.maximumLength(Int)` - The string's length must be less than or equal to the supplied value
- `.lengthWithinRange(Int, Int)` - The string's length must be within the supplied bounds, the first value must be less than the second, otherwise an error will be thrown.

### Comparable Validator

The `ComparableValidator` allows you to validate any Comparable type against another value of the same type, the library extends the built in `Int`, `Double` and `Float` types to be validateable using ComparableValidators.

- `.minimumValue(Self)`
- `.maximumValue(Self)`
- `.range(Self, Self)`

```swift
try 100.validValue(.minimumValue(50)) // pass

try 100.validValue(.minimumValue(400)) // fail

try 100.0.validValue(.range(0.1, 99.9)) // fail
```

## New types

### RegexPattern

RegexPattern is a protocol that custom types can conform to, the library extends `String` and any String `RawRepresentible` types to conform to `RegexPattern`. This means you can pass a String literal `.regex("^some regex pattern$")` or, even nicer create a String based enum and add conformance to `RegexPattern`. The library implements this design itself and comes with several built in regex patterns e.g. `.regex(StringValidationPattern.email)`.

```swift
public enum StringValidationPattern: String, RegexPattern {
    case alphaOnly = "^[a-zA-Z]*$"
    case numericOnly = "^[0-9]*$"
    case alphaNumericOnly = "^[a-zA-Z0-9]*$"
    case email = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$`"

    public var errorToThrow: ErrorType {
        switch self {
            case .alphaOnly: return StringValidationError.stringContainsNonAlphaCharacters
            case .numericOnly: return StringValidationError.stringContainsNonNumericCharacters
            case .alphaNumericOnly: return StringValidationError.stringContainsNonAlphaNumericCharacters
            case .email: return StringValidationError.stringIsNotAValidEmailAddress
        }
    }
}
```
