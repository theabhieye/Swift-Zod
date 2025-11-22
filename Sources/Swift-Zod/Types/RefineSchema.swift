//
//  RefineSchema.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// A wrapper schema that allows adding custom validation logic after
/// the base schema passes its built-in checks.
///
/// Example:
/// ```swift
/// let ageSchema = Z.number()
///     .min(0)
///     .refine("adultAge", message: "Must be at least 18") { $0 >= 18 }
///
/// try ageSchema.parse(17)
/// // ❌ throws ValidationError("[RefineError: adultAge] Must be at least 18")
/// ```
public final class RefineSchema<Base: Validator>: Schema<Base.Output> {
    private let base: Base
    private let name: String
    private let message: String
    private let validator: (Base.Output) -> Bool

    public init(
        base: Base,
        name: String,
        message: String,
        validator: @escaping (Base.Output) -> Bool
    ) {
        self.base = base
        self.name = name
        self.message = message
        self.validator = validator
        super.init()
    }

    override public func parse(_ value: Any) throws -> Base.Output {
        let parsed = try base.parse(value)
        guard validator(parsed) else {
            throw ValidationError("[RefineError: \(name)] \(message)")
        }
        return parsed
    }
}
