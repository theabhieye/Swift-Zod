//
//  StringSchema+CommonValidators.swift
//  Swift-Zod
//
//  Created by Abhishek Kapoor on 09/11/25.
//

import Foundation

public extension StringSchema {
    /// Validates that the string is a well-formed email address.
    @discardableResult
    func email() -> Self {
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return matches(pattern)
    }

    /// Validates that the string is a valid UUID.
    @discardableResult
    func uuid() -> Self {
        let pattern = #"^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[1-5][0-9A-Fa-f]{3}-[89ABab][0-9A-Fa-f]{3}-[0-9A-Fa-f]{12}$"#
        return matches(pattern)
    }

    /// Validates that the string is a valid URL.
    @discardableResult
    func url(allowedSchemes: [String] = ["http", "https"]) -> Self {
        return custom("url", message: "[StringSchemaError] Invalid URL") { string in
            guard let url = URL(string: string),
                  let scheme = url.scheme,
                  let host = url.host,
                  allowedSchemes.contains(scheme.lowercased()),
                  !host.isEmpty
            else { return false }
            return true
        }
    }

    /// Validates that the string is a valid phone number (7–15 digits, optional +).
    @discardableResult
    func phone() -> Self {
        let pattern = #"^\+?[0-9]{7,15}$"#
        return matches(pattern)
    }

    /// Validates that the string is alphanumeric.
    @discardableResult
    func alphanumeric() -> Self {
        let pattern = "^[A-Za-z0-9]+$"
        return matches(pattern)
    }
}
