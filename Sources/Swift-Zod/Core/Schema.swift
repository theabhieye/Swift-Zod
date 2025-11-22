//
//  Schema.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

/// Base abstract schema for building all validators.
///
/// Provides a default `safeParse` implementation that wraps `parse` in `do/catch`.
open class Schema<T>: Validator {
    public init() {}

    /// Validates and returns the strongly-typed result, or throws on failure.
    open func parse(_: Any) throws -> T {
        fatalError("Subclasses must implement parse()")
    }

    /// Wraps `parse(_:)` to provide a non-throwing version.
    public func safeParse(_ value: Any) -> SafeParseResult<T> {
        do {
            return try .success(parse(value))
        } catch let error as ValidationError {
            return .failure(error)
        } catch {
            return .failure(ValidationError("Unknown error"))
        }
    }
}
