//
//  Z.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// `Z` is the root namespace for all SwiftZod schemas.
///
/// This is the primary entry point for developers using your package.
/// It mirrors Zod's JavaScript-style API by exposing static methods that
/// create strongly-typed schema instances.
///
/// Example usage:
/// ```swift
/// let username = Z.string().min(3)
/// let score = Z.number().max(100)
///
/// try username.parse("Abhishek")
/// try score.parse(85)
/// ```
///
public enum Z {
    // MARK: - String Schema

    /// Creates a new schema for validating `String` values.
    ///
    /// Example:
    /// ```swift
    /// let username = Z.string().min(3).max(10)
    /// ```
    public static func string() -> StringSchema {
        return StringSchema()
    }

    // MARK: - Number Schema

    /// Creates a new schema for validating `Double` or `Int` values.
    ///
    /// Example:
    /// ```swift
    /// let score = Z.number().min(0).max(100)
    /// ```
    public static func number() -> NumberSchema {
        return NumberSchema()
    }

    // MARK: - Boolean Schema

    /// Creates a new schema for validating `Bool` values.
    ///
    /// Example:
    /// ```swift
    /// let isEnabled = Z.boolean()
    /// ```
    public static func boolean() -> BooleanSchema {
        return BooleanSchema()
    }

    // MARK: - Array Schema

    /// Creates a new schema for validating arrays.
    /// - Parameter elementSchema: The schema each element in the array must satisfy.
    /// - Returns: A new `ArraySchema` for the given element type.
    ///
    /// Example:
    /// ```swift
    /// let numbers = Z.array(Z.number().min(0))
    /// try numbers.parse([1, 2, 3])
    /// ```
    public static func array<T: Validator>(_ elementSchema: T) -> ArraySchema<T> {
        return ArraySchema(elementSchema)
    }

    // MARK: - Object Schema

    /// Creates a new schema for validating dictionary objects.
    ///
    /// Example:
    /// ```swift
    /// let user = Z.object([
    ///     "name": Z.string(),
    ///     "age": Z.number()
    /// ])
    /// ```
    public static func object(_ fields: [String: any Validator]) -> ObjectSchema {
        return ObjectSchema(fields)
    }

    // MARK: - Optional Schema

    /// Makes any schema optional, allowing `nil` values.
    ///
    /// Example:
    /// ```swift
    /// let name = Z.string().optional()
    /// try name.parse(nil) // ✅
    /// ```
    public static func optional<T: Validator>(_ schema: T) -> OptionalSchema<T> {
        return OptionalSchema(schema)
    }

    // MARK: - Enum Schema

    /// Creates a schema that validates values against a set of allowed string literals.
    ///
    /// Example:
    /// ```swift
    /// let Direction = Z.enum(["north", "south", "east", "west"])
    /// try Direction.parse("north") // ✅
    /// try Direction.parse("up")    // ❌
    /// ```
    public static func `enum`(_ values: [String]) -> EnumSchema {
        return EnumSchema(values)
    }

    // MARK: - Union Schema

    /// Creates a schema that validates a value against multiple schemas,
    /// passing if **any one** of them succeeds.
    ///
    /// Example:
    /// ```swift
    /// let ID = Z.union([Z.string().uuid(), Z.number().positive()])
    /// try ID.parse("b8d3c9a2-8f63-4f02-9955-8ed42c2b1a47") // ✅
    /// try ID.parse(42)                                     // ✅
    /// try ID.parse(false)                                  // ❌
    /// ```
    public static func union(_ schemas: [any Validator]) -> UnionSchema<Any> {
        UnionSchema<Any>(schemas)
    }

    public enum coerce {
        public static func string() -> CoerceSchema<StringSchema> {
            CoerceSchema(base: Z.string()) { value in
                if let str = value as? String { return str }
                if let convertible = value as? CustomStringConvertible { return String(describing: convertible) }
                // fallback for common numeric types
                if let int = value as? Int { return String(int) }
                if let dbl = value as? Double { return String(dbl) }
                if let bool = value as? Bool { return String(bool) }
                // cannot coerce
                return nil
            }
        }

        public static func number() -> CoerceSchema<NumberSchema> {
            CoerceSchema(base: Z.number()) { value in
                if let number = value as? Double { return number }
                if let int = value as? Int { return Double(int) }
                if let str = value as? String {
                    // Trim common whitespace/newline characters explicitly before parsing.
                    let trimmed = str.trimmingCharacters(in: .whitespacesAndNewlines)
                    // Accept leading/trailing plus/minus, decimals, and scientific notation.
                    if let parsed = Double(trimmed) {
                        return parsed
                    }
                    // Sometimes JSON decoding gives empty string — treat as failure (nil).
                    return nil
                }
                // cannot coerce
                return nil
            }
        }

        public static func boolean() -> CoerceSchema<BooleanSchema> {
            CoerceSchema(base: Z.boolean()) { value in
                if let bool = value as? Bool { return bool }
                if let int = value as? Int { return int != 0 }
                if let str = value as? String {
                    switch str.lowercased() {
                    case "true", "1", "yes", "y": return true
                    case "false", "0", "no", "n": return false
                    default: return nil
                    }
                }
                // cannot coerce
                return nil
            }
        }
    }
}
