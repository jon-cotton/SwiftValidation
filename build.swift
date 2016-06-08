#!/usr/bin/swift

import Foundation

let scheme = "SwiftValidation"
let project = "SwiftValidation.xcodeproj"
let simulator = "iPhone 6S,OS=9.3"

system("xcodebuild -scheme \(scheme) -project \(project) -sdk iphonesimulator -destination 'platform=iOS Simulator,name=\(simulator)' build test")