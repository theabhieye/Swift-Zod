//
//  DefaultSchema.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// A wrapper schema that applies a default value when the input is nil or missing.
public final class DefaultSchema<Wrapped: Validator>: Schema<Wrapped.Output> {
    private let wrapped: Wrapped
    private let defaultValue: Wrapped.Output

    public init(_ wrapped: Wrapped, defaultValue: Wrapped.Output) {
        self.wrapped = wrapped
        self.defaultValue = defaultValue
        super.init()
    }

    override public func parse(_ value: Any) throws -> Wrapped.Output {
        // If the value is explicitly NSNull or missing, return default
        if value is NSNull {
            return defaultValue
        }

        // Handle optional-nil case
        if let optional = value as? OptionalProtocol, optional.isNil {
            return defaultValue
        }

        // Otherwise, delegate to wrapped schema
        return try wrapped.parse(value)
    }
}

/// Internal protocol to expose default values inside `ObjectSchema`
protocol _DefaultSchemaProtocol {
    var _defaultValue: Any { get }
}

extension DefaultSchema: _DefaultSchemaProtocol {
    var _defaultValue: Any { defaultValue }
}
