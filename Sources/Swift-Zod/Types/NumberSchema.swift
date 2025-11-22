//
//  NumberSchema.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// A schema responsible for validating numeric values (`Int` or `Double`).
///
/// `NumberSchema` ensures a value is numeric and meets optional range constraints.
///
/// Example:
/// ```swift
/// let xp = Z.number().min(0).max(100)
/// try xp.parse(42)   // ✅
/// try xp.parse(-10)  // ❌ Throws ValidationError
/// ```
public final class NumberSchema: Schema<Double> {
    // MARK: - Configuration Properties

    private var minValue: Double?
    private var maxValue: Double?
    private var mustBePositive: Bool = false
    private var mustBeNegative: Bool = false

    // MARK: - Builder Modifiers

    /// Requires the number to be greater than or equal to the given minimum.
    /// - Parameter value: The minimum allowed value.
    /// - Returns: The same schema for chaining.
    @discardableResult
    public func min(_ value: Double) -> Self {
        minValue = value
        return self
    }

    /// Requires the number to be less than or equal to the given maximum.
    /// - Parameter value: The maximum allowed value.
    /// - Returns: The same schema for chaining.
    @discardableResult
    public func max(_ value: Double) -> Self {
        maxValue = value
        return self
    }

    /// Requires the number to be positive (greater than 0).
    /// - Returns: The same schema for chaining.
    @discardableResult
    public func positive() -> Self {
        mustBePositive = true
        return self
    }

    /// Requires the number to be negative (less than 0).
    /// - Returns: The same schema for chaining.
    @discardableResult
    public func negative() -> Self {
        mustBeNegative = true
        return self
    }

    // MARK: - Validation Logic

    /// Validates the provided value and ensures it meets numeric constraints.
    /// - Parameter value: The input value to validate.
    /// - Throws: `ValidationError` if validation fails.
    /// - Returns: The validated `Double` value.
    override public func parse(_ value: Any) throws -> Double {
        // Handle both Int and Double inputs
        guard let number = value as? Double ?? (value as? Int).map(Double.init) else {
            throw ValidationError("Expected number, got \(type(of: value))")
        }

        if let min = minValue, number < min {
            throw ValidationError("Expected number ≥ \(min) but got \(number)")
        }

        if let max = maxValue, number > max {
            throw ValidationError("Expected number ≤ \(max) but got \(number)")
        }

        if mustBePositive && number <= 0 {
            throw ValidationError("Expected a positive number but got \(number)")
        }

        if mustBeNegative && number >= 0 {
            throw ValidationError("Expected a negative number but got \(number)")
        }

        return number
    }
}
