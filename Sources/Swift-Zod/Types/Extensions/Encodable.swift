//
//  File 2.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

import Foundation

public extension Encodable {
    /// Converts any `Encodable` type into `[String: Any]` for validation.
    /// - Throws: `ValidationError` if serialization fails.
    func toDictionary() throws -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = jsonObject as? [String: Any] else {
                throw ValidationError("Failed to convert \(Self.self) to dictionary for validation.")
            }
            return dict
        } catch {
            throw ValidationError("Failed to encode \(Self.self) into dictionary: \(error.localizedDescription)")
        }
    }

    /// Validates an already-decoded `Encodable` instance using a schema.
    /// - Parameter schema: The `ObjectSchema` to validate the instance against.
    /// - Throws: `ValidationError` if validation fails.
    func validate(with schema: ObjectSchema) throws {
        let dict = try toDictionary()
        _ = try schema.parse(dict)
    }
}
