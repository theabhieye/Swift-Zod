//
//  OptionalSchema.swift
//  SwiftZod
//
//  Created by Abhishek Kapoor on 09/11/25.
//

import Foundation

/// A schema that allows `nil` values while wrapping another schema.
///
/// `OptionalSchema` acts as a decorator around any other schema,
/// making it accept `nil` or a valid value for the wrapped type.
///
/// Example:
/// ```swift
/// let name = Z.string().optional()
/// try name.parse(nil)        // ✅
/// try name.parse("Abhi")     // ✅
/// try name.parse(123)        // ❌
/// ```
public final class OptionalSchema<Wrapped: Validator>: Schema<Wrapped.Output?> {
    // MARK: - Properties

    private let wrapped: Wrapped

    // MARK: - Initializer

    public init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
        super.init()
    }

    // MARK: - Validation Logic

    override public func parse(_ value: Any) throws -> Wrapped.Output? {
        // Accept NSNull (useful when parsing JSON)
        if value is NSNull {
            return nil
        }

        // Handle Swift Optional.none (runtime detection)
        if let optionalValue = value as? OptionalProtocol, optionalValue.isNil {
            return nil
        }

        // Non-nil → validate using wrapped schema
        return try wrapped.parse(value)
    }
}

// MARK: - Optional Handling Helper

/// Allows runtime checking if a value is `Optional.none` even when erased to `Any`.
protocol OptionalProtocol {
    var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
    var isNil: Bool { self == nil }
}

// MARK: - OptionalSchema Type Detection Helper

protocol OptionalSchemaProtocol {}

extension OptionalSchema: OptionalSchemaProtocol {}
