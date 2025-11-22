//
//  SafeParseResult.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// Represents the outcome of a non-throwing validation attempt.
///
/// Similar to Zod’s `safeParse`, this allows branching between success/failure.
///
/// Example:
/// ```swift
/// let result = Z.string().safeParse(123)
/// switch result {
/// case .success(let value): print("✅", value)
/// case .failure(let error): print("❌", error.message)
/// }
/// ```
public enum SafeParseResult<T> {
    /// Parsing succeeded with a validated value.
    case success(T)

    /// Parsing failed with a validation error.
    case failure(ValidationError)
}

/// Adds `Equatable` conformance *only* when the wrapped type is also Equatable.
extension SafeParseResult: Equatable where T: Equatable {
    public static func == (lhs: SafeParseResult<T>, rhs: SafeParseResult<T>) -> Bool {
        switch (lhs, rhs) {
        case let (.success(lv), .success(rv)):
            return lv == rv
        case let (.failure(le), .failure(re)):
            return le == re
        default:
            return false
        }
    }
}
