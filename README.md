# Swift Validation [![Build Status](https://travis-ci.org/joncottonskyuk/SwiftValidation.svg?branch=master)](https://travis-ci.org/joncottonskyuk/SwiftValidation) [![codecov](https://codecov.io/gh/joncottonskyuk/SwiftValidation/branch/master/graph/badge.svg)](https://codecov.io/gh/joncottonskyuk/SwiftValidation)

Simple Validation library for Swift, adds validation directly to built in types String, Int, Double and Float

## Features
Adds the ability to validate String, Int, Double and Float values with basic validation rules out of the box. Also extends UITextField so you can easily test the validity of user input. The two base types `Validator` and `Validateable` are generic enough that they can be easily applied to any type, so you can add a set of validation rules for any custom type you create. Validation failures will throw 'multiple' errors, once for each failure, this allows you to quickly check a whole form of UITextFields for valid user input and report back all errors in a single pass.

An example project to show the library in use is available here: [Swift Validation Example](https://github.com/joncottonskyuk/SwiftValidationExample)

## Installation

### [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your Cartfile

`github "joncottonskyuk/SwiftValidation"`

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
} catch let UIError as ValidationUserInputError {
    /*
    ValidationUserInputError is a wrapper around an AggregateError that also has a UIElement property
    that holds a reference to the UIControl that the error relates to, this allows you to check multiple
    fields in a single do-catch and then tie the errors back up the relevant UIControl later.
    */
    print(UIError.errors.reduce("", combine: { "\($0) \($1)" }))
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
- `.lengthWithinRange(Int, Int)` - The string's length must be within the supplied bounds. The lowest value is presumed to be the min and highest value the max, so values can be supplied in any order.
- `.oneOf([String])` - The string's value must match one of the supplied values in the array.

#### Built in regex patterns
The library comes with a set of basic regex patterns that you can use to validate strings with...
```swift
public enum StringValidationPattern: String, RegexPattern {
    case alphaOnly = "^[a-zA-Z]*$"
    case numericOnly = "^[0-9]*$"
    case alphaNumericOnly = "^[a-zA-Z0-9]*$"
    case email = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"

    public var errorToThrowOnFailure: ErrorType {
        switch self {
            case .alphaOnly: return StringValidationError.stringContainsNonAlphaCharacters
            case .numericOnly: return StringValidationError.stringContainsNonNumericCharacters
            case .alphaNumericOnly: return StringValidationError.stringContainsNonAlphaNumericCharacters
            case .email: return StringValidationError.stringIsNotAValidEmailAddress
        }
    }
}
```

In use...
```swift
let validString = try "someString".validValue(.regex(StringValidationPattern.alphaOnly))
```

#### Providing custom regex patterns

If you need to do more complex string validation with a custom regex pattern, you can just use a string literal to inject your custom pattern e.g. `let validString = try "someString".validValue(.regex("^[a-zA-Z*%$£@!]*$"))`. A nicer way to provide custom patterns though is to create a String based enum that conforms to the [RegexPattern](#regexpattern) protocol. All String RawRepresentibles already have default functionality to provide the rawValue as the regex pattern, so you only need to create your enum and assign the pattern to each case, like so...
```swift
enum UserValidationPattern: String, RegexPattern {
    case password = "^[a-zA-Z0-9*_\\-&%\\$£@]$"
}
```

Then in use, you can just pass the enum case directly, without having to extract the rawValue yourself
```swift
passwordTextField.validValue(.regex(UserValidationPattern.password), .lengthWithinRange(8, 32), .match(passwordConfirmation))
```

The default behaviour is to throw a `RegexError.stringDoesNotMatchRegexPattern` error if the pattern fails to match the string. You can also provide a custom error to throw by implementing the `errorToThrowOnFailure` property in your custom RegexPattern, e.g...
```swift
enum UserValidationError: ErrorType {
    case passwordIsUnexpectedFormat
}

enum UserValidationPattern: String, RegexPattern {
    case password = "^[a-zA-Z0-9*_\\-&%\\$£@]$"

    var errorToThrowOnFailure: ErrorType? {
        switch self {
            case .password: return UserValidationError.passwordIsUnexpectedFormat
        }
    }
}
```

### Comparable Validator

The `ComparableValidator` allows you to validate any `Comparable` type against another value of the same type, the library extends the built in `Int`, `Double` and `Float` types to be validateable using ComparableValidators.

- `.minimumValue(Self)`
- `.maximumValue(Self)`
- `.range(Self, Self)`

```swift
try 100.validValue(.minimumValue(50)) // pass

try 100.validValue(.minimumValue(400)) // fail

try 100.0.validValue(.range(0.1, 99.9)) // fail
```

### Writing a custom Validator

If you have a custom type that you want to be able to validate, you just need to make the type conform to [Validateable](#validateable) by providing a [Validator](#validator) that can validate your type.

If you had a `Person` type that looked like...
```swift
struct Person {
    var firstname = ""
    var surname = ""
    var age = 0
    var emailAddress: String?
}
```

You would first need a `PersonValidator` that conforms to [Validator](#validator) and an error to throw on failure...
```swift
struct PersonValidator: Validator {
    func isValid(value: Person) throws -> Bool {
        let person = value

        // only adults with email addresses are valid people
        guard person.age >= 18 && person.emailAddress != nil  else {
            throw PersonValidationError.notAValidPerson
        }

        return true
    }
}

enum PersonValidationError: ErrorType {
    case notAValidPerson
}
```

You then just need to make Person conform to [Validateable](#validateable). The default behaviour already provided by the protocol extension is usually ok, you just need to resolve the generic `ValidatorType` to the Validator you've just created...

```swift
extension Person: Validateable {
    typealias ValidatorType = PersonValidator
}
```

Now you can validate a person...
```swift
// The following code prints notAValidPerson to console
var somebody = Person()
somebody.firstname = "Jim"
somebody.surname = "Robinson"
somebody.age = 12

do {
    let validPerson = try somebody.validValue(PersonValidator())
} catch let errors as AggregateError {
    print(errors.reduce("", combine: { "\($0) \($1)" }))
} catch {
    // Another error occurred
}
```

You can of course be more granular with your validation rules, a nicer way to implement the PersonValidator above might be...
```swift
enum PersonValidator: Validator {
    case mustBeAdult
    case mustHaveEmailAddress
    case surnameMustBeLongerThan(Int)

    func isValid(value: Person) throws -> Bool {
        let person = value

        switch self {
        case .mustBeAdult:
            guard person.age >= 18  else {
                 throw PersonValidationError.personIsNotAnAdult
            }

        case .mustHaveEmailAddress:
            guard person.emailAddress != nil else {
                throw PersonValidationError.personDoesNotHaveAnEmailAddress
            }

        case .surnameMustBeLongerThan(let minLength):
            guard person.surname.characters.count >= minLength else {
                throw PersonValidationError.personsSurnameIsTooShort
            }
        }

        return true
    }
}

enum PersonValidationError: ErrorType {
    case personIsNotAnAdult
    case personDoesNotHaveAnEmailAddress
    case personsSurnameIsTooShort
}
```

In use...
```swift
// The following code prints personIsNotAnAdult personDoesNotHaveAnEmailAddress to console
do {
    let validPerson = try somebody.validValue(.mustBeAdult, .mustHaveEmailAddress)
} catch let errors as AggregateError {
    print(errors.reduce("", combine: { "\($0) \($1)" }))
} catch {
    // Another error occurred
}
```

## New types

### Validator

All Validators must conform to the generic protocol `Validator`, there is no default implementation for `isValid()` so you must implement that your self when conforming to this protocol. The Generic type should be resolved when you provide your implementation of `isValid()`.

```swift
public protocol Validator {
    associatedtype T

    func isValid(value: T) throws -> Bool
}
```

### Validateable

To make a type validateable, you need to conform to the `Validateable` protocol, a default implementation of `validValue()` is already provided and should be ok for most types. The only thing you need to add when conforming to the protocol is usually the resolution of the Generic type ValidatorType which should just be the type of the custom `Validator` you write to validate the type you want to make `Validateable`.

```swift
public protocol Validateable {
    associatedtype ValidatorType: Validator

    func validValue(validators: ValidatorType...) throws -> ValidatorType.T
}
```

### RegexPattern

RegexPattern is a protocol that custom types can conform to, the library extends `String` and any String `RawRepresentible` types to conform to `RegexPattern`. This means you can pass a String literal `.regex("^some regex pattern$")` or, even nicer create a String based enum and add conformance to `RegexPattern`. `match()` and `errorToThrowOnFailure` already have default implementations for all types, the pattern property is implemented for String and RawRepresentible where RawValue == String.

```swift
public protocol RegexPattern {
    var pattern: String {get}
    var errorToThrowOnFailure: ErrorType? {get}

    func match(string: String) throws -> Bool
}
```
