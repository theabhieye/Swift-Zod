//
//  TransformSchema.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// A schema wrapper that transforms the validated output of another schema
/// into a new value or type.
///
/// Example:
/// ```swift
/// // Convert a validated string into an integer
/// let schema = Z.string()
///     .refine("digitsOnly", message: "Must contain only digits") { $0.allSatisfy(\.isNumber) }
///     .transform { Int($0)! }
///
/// try schema.parse("123") // ✅ returns Int(123)
/// ```
///
/// The transform closure receives the successfully validated output
/// of the wrapped schema and returns a new value. It may throw
/// if the transformation fails.
public final class TransformSchema<Base: Validator, Output>: Schema<Output> {
    private let base: Base
    private let transformer: (Base.Output) throws -> Output

    public init(base: Base, transform: @escaping (Base.Output) throws -> Output) {
        self.base = base
        transformer = transform
        super.init()
    }

    override public func parse(_ value: Any) throws -> Output {
        let parsed = try base.parse(value)
        return try transformer(parsed)
    }
}
