//
//  TransformSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import SwiftZod
import XCTest

final class TransformSchemaTests: XCTestCase {
    func test_transform_string_to_int() throws {
        let schema = Z.string()
            .refine("digitsOnly", message: "Must be numeric") { $0.allSatisfy(\.isNumber) }
            .transform { Int($0)! }

        let result = try schema.parse("123")
        XCTAssertEqual(result, 123)
    }

    func test_transform_trims_and_lowercases() throws {
        let schema = Z.string()
            .transform { $0.trimmingCharacters(in: .whitespaces).lowercased() }

        let result = try schema.parse("  HELLO ")
        XCTAssertEqual(result, "hello")
    }

    func test_transform_chain_with_refine() throws {
        let schema = Z.number()
            .refine("positive", message: "Must be positive") { $0 > 0 }
            .transform { Int($0) }

        let result = try schema.parse(42.0)
        XCTAssertEqual(result, 42)
    }

    func test_transform_failure_propagates() {
        let schema = Z.string()
            .transform { _ in throw ValidationError("Transform failed") }

        XCTAssertThrowsError(try schema.parse("abc")) { error in
            let e = error as? ValidationError
            XCTAssertTrue(e?.message.contains("Transform failed") ?? false)
        }
    }
}
