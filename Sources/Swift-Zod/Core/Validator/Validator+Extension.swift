//
//  Validator+Extension.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

public extension Validator {
    /// Returns an optional version of this schema.
    /// Example:
    /// ```swift
    /// let age = Z.number().optional()
    /// try age.parse(nil) // ✅
    /// ```
    func optional() -> OptionalSchema<Self> {
        OptionalSchema(self)
    }

    /// Provides a default value if the field is missing or `nil`.
    ///
    /// - Parameter value: The default value to use when the input is absent.
    /// - Returns: A wrapped schema that supplies a default when validation input is missing.
    @discardableResult
    func `default`(_ value: Output) -> DefaultSchema<Self> {
        DefaultSchema(self, defaultValue: value)
    }

    /// Adds an additional validation step after the base schema succeeds.
    ///
    /// - Parameters:
    ///   - name: A short name for debugging or error tracing.
    ///   - message: Message thrown when refinement fails.
    ///   - validator: Closure that receives the parsed value and returns `true`
    ///                if valid, otherwise `false`.
    ///
    /// Example:
    /// ```swift
    /// Z.string().refine("username", message: "Must not contain spaces") { !$0.contains(" ") }
    /// ```
    @discardableResult
    func refine(
        _ name: String = "refine",
        message: String,
        validator: @escaping (Output) -> Bool
    ) -> RefineSchema<Self> {
        RefineSchema(base: self, name: name, message: message, validator: validator)
    }

    /// Transforms the successfully validated value into a new value or type.
    ///
    /// - Parameter transform: A closure that receives the parsed output and returns a new transformed value.
    /// - Returns: A schema that outputs the transformed type.
    ///
    /// Example:
    /// ```swift
    /// Z.string()
    ///     .transform { $0.trimmingCharacters(in: .whitespaces).lowercased() }
    /// ```
    @discardableResult
    func transform<T>(_ transform: @escaping (Output) throws -> T) -> TransformSchema<Self, T> {
        TransformSchema(base: self, transform: transform)
    }
}
