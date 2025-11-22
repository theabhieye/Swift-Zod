//
//  BooleanSchema.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// A schema responsible for validating boolean (`Bool`) values.
///
/// Example:
/// ```swift
/// let isActive = Z.boolean()
/// try isActive.parse(true)   // ✅
/// try isActive.parse("true") // ❌ Throws ValidationError
/// ```
public final class BooleanSchema: Schema<Bool> {
    // MARK: - Configuration Properties

    private var mustBeTrue: Bool = false
    private var mustBeFalse: Bool = false

    // MARK: - Builder Modifiers

    /// Ensures the value is explicitly `true`.
    @discardableResult
    public func trueOnly() -> Self {
        mustBeTrue = true
        return self
    }

    /// Ensures the value is explicitly `false`.
    @discardableResult
    public func falseOnly() -> Self {
        mustBeFalse = true
        return self
    }

    // MARK: - Validation Logic

    override public func parse(_ value: Any) throws -> Bool {
        guard let bool = value as? Bool else {
            throw ValidationError("Expected boolean, got \(type(of: value))")
        }

        if mustBeTrue && bool == false {
            throw ValidationError("[BooleanSchemaError] Expected `true` but got `false`.")
        }

        if mustBeFalse && bool == true {
            throw ValidationError("[BooleanSchemaError] Expected `false` but got `true`.")
        }

        return bool
    }
}
