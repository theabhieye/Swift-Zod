//
//  EnumSchema.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// A schema for validating values against a fixed set of allowed literals.
///
/// Similar to `z.enum()` in Zod, this schema restricts input
/// to one of the predefined string (or comparable) cases.
///
/// Example:
/// ```swift
/// let Size = Z.enum(["small", "medium", "large"])
/// try Size.parse("medium") // ✅
/// try Size.parse("giant")  // ❌
/// ```
public final class EnumSchema: Schema<String> {
    // MARK: - Properties

    private let allowedValues: [String]

    // MARK: - Initializer

    /// Creates an enum schema with the specified allowed values.
    /// - Parameter values: The array of allowed string literals.
    public init(_ values: [String]) {
        precondition(!values.isEmpty, "Enum must have at least one value.")
        allowedValues = values
        super.init()
    }

    // MARK: - Validation Logic

    override public func parse(_ value: Any) throws -> String {
        guard let stringValue = value as? String else {
            throw ValidationError("Expected string enum, got \(type(of: value))")
        }

        guard allowedValues.contains(stringValue) else {
            throw ValidationError(
                "Expected one of \(allowedValues), got '\(stringValue)'."
            )
        }

        return stringValue
    }
}
