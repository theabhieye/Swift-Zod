//
//  UnionSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import SwiftZod
import XCTest

final class UnionSchemaTests: XCTestCase {
    func test_union_accepts_string_or_number() throws {
        let schema = Z.union([Z.string(), Z.number()])

        XCTAssertEqual(try schema.parse("hello") as? String, "hello")
        XCTAssertEqual(try schema.parse(42) as? Double, 42.0)
    }

    func test_union_rejects_unmatched_type() {
        let schema = Z.union([Z.string(), Z.number()])

        XCTAssertThrowsError(try schema.parse(true)) { error in
            let validationError = error as? ValidationError
            XCTAssertTrue(validationError?.message.contains("UnionSchemaError") ?? false)
        }
    }

    func test_union_combines_error_messages() {
        let schema = Z.union([Z.string().uuid(), Z.number().positive()])

        XCTAssertThrowsError(try schema.parse(false)) { error in
            let validationError = error as? ValidationError
            XCTAssertTrue(
                validationError?.message.contains("Value did not match any union type") ?? false
            )
        }
    }

    func test_union_returns_first_successful_schema() throws {
        let schema = Z.union([
            Z.string().refine("containsA", message: "Must contain A") { $0.contains("A") },
            Z.string().refine("containsB", message: "Must contain B") { $0.contains("B") },
        ])

        let result = try schema.parse("Banana")
        XCTAssertEqual(result as? String, "Banana")
    }

    func test_union_nested_in_array() throws {
        let schema = Z.array(Z.union([Z.string(), Z.number()]))

        let result = try schema.parse(["Swift", 5, "Zod"])
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0] as? String, "Swift")
        XCTAssertEqual(result[1] as? Double, 5.0)
    }
}
