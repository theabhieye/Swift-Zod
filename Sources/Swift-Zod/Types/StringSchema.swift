//
//  StringSchema.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// A schema responsible for validating `String` values.
///
/// `StringSchema` allows you to:
/// - Enforce minimum and maximum lengths
/// - Match custom regex patterns
/// - Extend future modifiers like `.email()`, `.uuid()`, `.url()`
///
/// Example:
/// ```swift
/// let username = Z.string().min(3).max(12)
/// try username.parse("Abhishek") // ✅
/// try username.parse("A")        // ❌ Throws ValidationError
/// ```
public final class StringSchema: Schema<String> {
    // MARK: - Configuration Properties

    private var minLength: Int?
    private var maxLength: Int?
    private var regex: NSRegularExpression?
    private var customRules: [(name: String, validator: (String) -> Bool, message: String)] = []

    // MARK: - Builder Modifiers

    /// Sets the minimum number of characters allowed.
    /// - Parameter length: Minimum required length.
    /// - Returns: The same schema for chaining.
    @discardableResult
    public func min(_ length: Int) -> Self {
        precondition(length >= 0, "Minimum length must be non-negative.")
        minLength = length
        return self
    }

    /// Sets the maximum number of characters allowed.
    /// - Parameter length: Maximum allowed length.
    /// - Returns: The same schema for chaining.
    @discardableResult
    public func max(_ length: Int) -> Self {
        precondition(length >= 0, "Maximum length must be non-negative.")
        maxLength = length
        return self
    }

    /// Ensures the string matches a provided regular expression pattern.
    /// - Parameter pattern: A valid regex pattern.
    /// - Returns: The same schema for chaining.
    @discardableResult
    public func matches(_ pattern: String) -> Self {
        do {
            regex = try NSRegularExpression(pattern: pattern)
        } catch {
            assertionFailure("Invalid regex pattern: \(pattern)")
        }
        return self
    }

    // MARK: - Validation Logic

    /// Validates the provided value and ensures it meets string constraints.
    /// - Parameter value: The input value to validate.
    /// - Throws: `ValidationError` if validation fails.
    /// - Returns: The validated `String` value.
    override public func parse(_ value: Any) throws -> String {
        guard let string = value as? String else {
            throw ValidationError("Expected string, got \(type(of: value))")
        }

        if let min = minLength, string.count < min {
            throw ValidationError(
                "[StringSchemaError] Expected at least \(min) characters but got \(string.count)."
            )
        }

        if let max = maxLength, string.count > max {
            throw ValidationError(
                "[StringSchemaError] Expected at most \(max) characters but got \(string.count)."
            )
        }

        if let regex = regex {
            let range = NSRange(string.startIndex ..< string.endIndex, in: string)
            let hasMatch = regex.firstMatch(in: string, range: range) != nil

            if !hasMatch {
                throw ValidationError(
                    "[StringSchemaError] Invalid input: '\(string)' does not match pattern '\(regex.pattern)'"
                )
            }
        }

        for rule in customRules where !rule.validator(string) {
            throw ValidationError("[StringSchemaError] \(rule.message)")
        }

        return string
    }

    /// Adds a custom validation rule to the string schema.
    /// - Parameters:
    ///   - name: A short identifier for the rule.
    ///   - message: Optional custom error message.
    ///   - validator: Closure returning `true` if the string is valid.
    /// - Returns: The same schema instance for chaining.
    @discardableResult
    public func custom(
        _ name: String,
        message: String? = nil,
        validator: @escaping (String) -> Bool
    ) -> Self {
        customRules.append((
            name: name,
            validator: validator,
            message: message ?? "Failed rule '\(name)'"
        ))
        return self
    }
}
