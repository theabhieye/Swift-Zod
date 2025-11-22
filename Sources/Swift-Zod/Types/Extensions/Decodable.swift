//
//  Decodable.swift
//  Swift-Zod
//
//  Created by Abhishek Kapoor on 09/11/25.
//

import Foundation

/// Convenience helper to decode a `Decodable & Encodable` type from JSON data
/// and validate the resulting instance against an `ObjectSchema`.
/// - Parameters:
///   - data: JSON data to decode.
///   - schema: The `ObjectSchema` used to validate the decoded value.
///   - decoder: Optional custom `JSONDecoder`.
/// - Throws: Any decoding error or `ValidationError` from schema parsing.
/// - Returns: The decoded and validated instance.
public extension Decodable where Self: Encodable {
    static func decodeAndValidate(
        from data: Data,
        schema: ObjectSchema,
        using decoder: JSONDecoder = .init()
    ) throws -> Self {
        let decoded = try decoder.decode(Self.self, from: data)
        let dict = try decoded.toDictionary() // toDictionary requires Encodable
        _ = try schema.parse(dict)
        return decoded
    }
}
