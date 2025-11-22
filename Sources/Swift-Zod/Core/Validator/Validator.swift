//
//  Validator.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// `Validator` defines the base contract that all schemas in SwiftZod must implement.
///
/// Conforming types specify an `Output` type representing the validated data,
/// and implement methods for strict (`parse`) and safe (`safeParse`) validation.
public protocol Validator {
    associatedtype Output

    /// Strictly validates the given value.
    ///
    /// - Parameter value: The input value to validate.
    /// - Throws: `ValidationError` if validation fails.
    /// - Returns: The validated and typed value.
    func parse(_ value: Any) throws -> Output

    /// Safely validates the value, returning a structured result instead of throwing.
    ///
    /// - Parameter value: The input value to validate.
    /// - Returns: `.success(validValue)` if valid, `.failure(error)` otherwise.
    func safeParse(_ value: Any) -> SafeParseResult<Output>
}
