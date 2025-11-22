//
//  AnyValidator.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// Type-erased validator that can hold any concrete schema.
///
/// Used internally by `UnionSchema` to allow heterogeneous schemas
/// (e.g., string OR number) without triggering generic constraints.
public struct AnyValidator {
    private let _parse: (Any) throws -> Any
    private let _safeParse: (Any) -> SafeParseResult<Any>

    public init<V: Validator>(_ validator: V) {
        _parse = { try validator.parse($0) }
        _safeParse = { value in
            switch validator.safeParse(value) {
            case let .success(output):
                return .success(output)
            case let .failure(error):
                return .failure(error)
            }
        }
    }

    public func parse(_ value: Any) throws -> Any {
        try _parse(value)
    }

    public func safeParse(_ value: Any) -> SafeParseResult<Any> {
        _safeParse(value)
    }
}
