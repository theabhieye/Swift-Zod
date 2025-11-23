//
//  RefineSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import SwiftZod
import XCTest

final class RefineSchemaTests: XCTestCase {
    func test_refine_passes_for_valid_value() throws {
        let schema = Z.number().refine("positive", message: "Must be positive") { $0 > 0 }
        let result = try schema.parse(10)
        XCTAssertEqual(result, 10)
    }

    func test_refine_fails_for_invalid_value() throws {
        let schema = Z.number().refine("positive", message: "Must be positive") { $0 > 0 }
        XCTAssertThrowsError(try schema.parse(-5)) { error in
            let validationError = error as? ValidationError
            XCTAssertTrue(validationError?.message.contains("Must be positive") ?? false)
        }
    }

    func test_refine_chain_with_string_rules() throws {
        let schema = Z.string()
            .min(3)
            .refine("noSpaces", message: "Cannot contain spaces") { !$0.contains(" ") }

        XCTAssertNoThrow(try schema.parse("John"))
        XCTAssertThrowsError(try schema.parse("John Doe"))
    }

    func test_refine_on_object_level() throws {
        let schema = Z.object([
            "password": Z.string().min(8),
            "confirm": Z.string().min(8),
        ]).refine("match", message: "Passwords must match") { dict in
            dict["password"] as? String == dict["confirm"] as? String
        }

        let valid = try schema.parse(["password": "abcdefgh", "confirm": "abcdefgh"])
        XCTAssertEqual(valid["password"] as? String, "abcdefgh")

        XCTAssertThrowsError(
            try schema.parse(["password": "abcdefgh", "confirm": "xyz12345"])
        )
    }
}
