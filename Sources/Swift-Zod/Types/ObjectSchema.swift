//
//  ObjectSchema.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// A schema responsible for validating Swift dictionaries (`[String: Any]`)
/// against a set of field schemas.
///
/// This is the foundation for structured data validation in SwiftZod,
/// mirroring Zod's `z.object({...})` API.
///
/// Example:
/// ```swift
/// let Player = Z.object([
///     "username": Z.string().min(3),
///     "xp": Z.number().min(0)
/// ])
///
/// try Player.parse(["username": "Abhi", "xp": 42]) // ✅
/// try Player.parse(["username": 1, "xp": "oops"])  // ❌
/// ```
public final class ObjectSchema: Schema<[String: Any]> {
    // MARK: - Internal Schema Map

    private let fields: [String: any Validator]

    // MARK: - Initializer

    /// Initializes an `ObjectSchema` with a dictionary of field schemas.
    /// - Parameter fields: A mapping of field names to their corresponding schema.
    public init(_ fields: [String: any Validator]) {
        self.fields = fields
        super.init()
    }

    // MARK: - Validation Logic

    /// Validates that the provided value is a `[String: Any]` dictionary,
    /// and that each key passes validation according to its schema.
    override public func parse(_ value: Any) throws -> [String: Any] {
        guard let dict = value as? [String: Any] else {
            throw ValidationError("Expected object, got \(type(of: value))")
        }

        var result: [String: Any] = [:]

        for (key, validator) in fields {
            // If key missing from input dictionary
            guard let fieldValue = dict[key] else {
                // If validator provides a default, use it
                if let defaultSchema = _findDefaultSchema(in: validator) {
                    result[key] = defaultSchema._defaultValue
                    continue
                }
                // If validator is optional, allow nil
                if validator is any OptionalSchemaProtocol {
                    result[key] = nil
                    continue
                }
                throw ValidationError("[ObjectSchemaError] Missing required field '\(key)'", path: [key])
            }

            do {
                let parsedValue = try _parseUsingValidator(validator, value: fieldValue)
                result[key] = parsedValue
            } catch let err as ValidationError {
                throw ValidationError(
                    "[ObjectSchemaError] Field '\(key)' failed validation: \(err.message)",
                    path: err.path + [key]
                )
            } catch {
                throw ValidationError("[ObjectSchemaError] Unknown validation error at key '\(key)'.")
            }
        }

        return result
    }

    // MARK: - Internal Helper

    /// Internal helper that takes an existential validator (`any Validator`)
    /// and uses `AnyValidator` to perform parsing returning `Any`.
    private func _parseUsingValidator(_ validator: any Validator, value: Any) throws -> Any {
        return try AnyValidator(validator).parse(value)
    }

    /// Recursively finds a DefaultSchema even if it's nested inside OptionalSchema
    private func _findDefaultSchema(
        in validator: any Validator
    ) -> (any _DefaultSchemaProtocol)? {
        // Directly a DefaultSchema
        if let defaultSchema = validator as? any _DefaultSchemaProtocol {
            return defaultSchema
        }

        // If validator is an OptionalSchema, check inside its `wrapped` property
        if let mirrorChild = Mirror(reflecting: validator)
            .children
            .first(
                where: {
                    $0.label == "wrapped"
                })?.value as?
            any Validator {
            return _findDefaultSchema(in: mirrorChild)
        }

        return nil
    }
}
