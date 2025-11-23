//
//  DefaultSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import SwiftZod
import XCTest

final class DefaultSchemaTests: XCTestCase {
    func test_string_default_applies_when_missing() throws {
        let schema = Z.object([
            "name": Z.string().default("Guest"),
        ])

        let input: [String: Any] = [:]
        let result = try schema.parse(input)

        XCTAssertEqual(result["name"] as? String, "Guest")
    }

    func test_number_default_applies_when_null() throws {
        let schema = Z.object([
            "age": Z.number().default(18),
        ])

        let input: [String: Any] = ["age": NSNull()]
        let result = try schema.parse(input)

        XCTAssertEqual(result["age"] as? Double, 18.0)
    }

    func test_boolean_default_applies_when_missing() throws {
        let schema = Z.object([
            "active": Z.boolean().default(true),
        ])

        let input: [String: Any] = [:]
        let result = try schema.parse(input)

        XCTAssertEqual(result["active"] as? Bool, true)
    }

    func test_default_is_not_applied_when_value_present() throws {
        let schema = Z.object([
            "age": Z.number().default(18),
        ])

        let input: [String: Any] = ["age": 25]
        let result = try schema.parse(input)

        XCTAssertEqual(result["age"] as? Double, 25.0)
    }

    func test_default_works_with_optional_schema() throws {
        let schema = Z.object([
            "nickname": Z.string().optional().default("N/A"),
        ])

        let result = try schema.parse([:])
        XCTAssertEqual(result["nickname"] as? String, "N/A")
    }

    func test_default_throws_if_type_invalid() throws {
        let schema = Z.object([
            "age": Z.number().default(10),
        ])

        let input: [String: Any] = ["age": "notANumber"]

        XCTAssertThrowsError(try schema.parse(input)) { error in
            let validationError = error as? ValidationError
            XCTAssertTrue(validationError?.message.contains("Expected number") ?? false)
        }
    }

    func test_optional_then_default_applies_when_missing() throws {
        let schema = Z.object([
            "name": Z.string().optional().default("Guest"),
        ])

        let input: [String: Any] = [:]
        let result = try schema.parse(input)

        XCTAssertEqual(result["name"] as? String, "Guest")
    }

    func test_optional_then_default_applies_when_nil() throws {
        let schema = Z.object([
            "name": Z.string().optional().default("Guest"),
        ])

        let input: [String: Any] = ["name": NSNull()]
        let result = try schema.parse(input)

        XCTAssertEqual(result["name"] as? String, "Guest")
    }

    func test_optional_then_default_not_applied_when_present() throws {
        let schema = Z.object([
            "name": Z.string().optional().default("Guest"),
        ])

        let input: [String: Any] = ["name": "Abhishek"]
        let result = try schema.parse(input)

        XCTAssertEqual(result["name"] as? String, "Abhishek")
    }

    func test_default_then_optional_applies_when_missing() throws {
        let schema = Z.object([
            "name": Z.string().default("Guest").optional(),
        ])

        let input: [String: Any] = [:]
        let result = try schema.parse(input)

        // Missing → default applies
        XCTAssertEqual(result["name"] as? String, "Guest")
    }

    func test_default_then_optional_preserves_value_when_present() throws {
        let schema = Z.object([
            "name": Z.string().default("Guest").optional(),
        ])

        let input: [String: Any] = ["name": "John"]
        let result = try schema.parse(input)

        XCTAssertEqual(result["name"] as? String, "John")
    }
}
