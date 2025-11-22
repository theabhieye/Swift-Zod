//
//  CoerceSchema.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// Attempts to coerce raw input into a form consumable by `base` validator.
/// If the coercer returns `nil`, parsing fails with a clear `ValidationError`.
public final class CoerceSchema<Base: Validator>: Schema<Base.Output> {
    private let base: Base
    /// Coercer should return the coerced value, or `nil` to indicate coercion failure.
    private let coercer: (Any) -> Any?

    public init(base: Base, coercer: @escaping (Any) -> Any?) {
        self.base = base
        self.coercer = coercer
        super.init()
    }

    override public func parse(_ value: Any) throws -> Base.Output {
        guard let coerced = coercer(value) else {
            throw ValidationError("[CoerceSchemaError] Failed to coerce value '\(value)' to expected type.")
        }

        do {
            return try base.parse(coerced)
        } catch let err as ValidationError {
            // Provide clearer context that coercion worked but base parse failed
            throw ValidationError("[CoerceSchemaError] \(err.message)", path: err.path)
        } catch {
            throw ValidationError("[CoerceSchemaError] Unknown error while parsing coerced value.")
        }
    }
}
