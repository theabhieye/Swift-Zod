//
//  ValidationError.swift
//  SwiftZod
//
//  Created by Abhishek Kapoor on 09/11/25.
//

import Foundation

/// Describes a validation failure.
///
/// Each `ValidationError` contains:
/// - A human-readable message
/// - An optional `path` showing where in a nested object the error occurred
///
/// `ValidationError` conforms to `Equatable` so it can be used in tests easily.
// public struct ValidationError: Error, CustomStringConvertible, Equatable {
//    /// Human-readable error message.
//    public let message: String
//
//    /// Nested key path leading to the invalid value.
//    public let path: [String]
//
//    public var description: String { message }
//
//    public init(_ message: String, path: [String] = []) {
//        self.message = message
//        self.path = path
//    }
// }

public struct ValidationError: Error, CustomStringConvertible, Equatable {
    public let message: String
    public let path: [String]

    public init(_ message: String, path: [String] = []) {
        self.message = message
        self.path = path
    }

    /// Returns a human-readable path like `"user.address.city"`.
    public var formattedPath: String {
        guard !path.isEmpty else { return "" }
        return path.reversed().joined(separator: ".")
    }

    /// Returns a formatted string combining path and message.
    public var formattedDescription: String {
        if formattedPath.isEmpty {
            return message
        } else {
            return "\(formattedPath): \(message)"
        }
    }

    public var description: String { formattedDescription }

    public static func == (lhs: ValidationError, rhs: ValidationError) -> Bool {
        lhs.message == rhs.message && lhs.path == rhs.path
    }
}
