//
//  OptionalSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import SwiftZod
import XCTest

final class OptionalSchemaTests: XCTestCase {
    func testNonNilValidValue() throws {
        let schema = Z.number().optional()
        XCTAssertEqual(try schema.parse(42), 42)
    }

    func testInvalidValueFails() {
        let schema = Z.string().optional()
        XCTAssertThrowsError(try schema.parse(123)) { error in
            XCTAssertEqual(error as? ValidationError,
                           ValidationError("Expected string, got Int"))
        }
    }

    func testSafeParseInvalidValue() {
        let schema = Z.number().optional()
        let result = schema.safeParse("oops")

        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case let .failure(err):
            XCTAssertTrue(err.message.contains("Expected number"))
        }
    }

    func testOptionalAllowsNil() {
        let schema = Z.optional(Z.string())
        let maybeNil: Any? = nil
        let result = schema.safeParse(maybeNil as Any)

        switch result {
        case let .success(value):
            XCTAssertNil(value, "Expected success with nil value")
        case let .failure(error):
            XCTFail("Expected success, got failure: \(error.message)")
        }
    }

    func testOptionalAllowsNSNull() {
        let schema = Z.optional(Z.string())
        let result = schema.safeParse(NSNull())

        switch result {
        case let .success(value):
            XCTAssertNil(value, "Expected success with nil for NSNull")
        case let .failure(error):
            XCTFail("Expected success, got failure: \(error.message)")
        }
    }

    // MARK: - Success: Valid Wrapped Value

    func testOptionalParsesValidValue() throws {
        let schema = Z.optional(Z.string())
        let result = try schema.parse("SwiftZod")
        XCTAssertEqual(result, "SwiftZod")
    }

    // MARK: - Failure: Invalid Wrapped Type

    func testOptionalFailsForInvalidWrappedValue() {
        let schema = Z.optional(Z.string())

        XCTAssertThrowsError(try schema.parse(42)) { error in
            guard let validationError = error as? ValidationError else {
                XCTFail("Expected ValidationError, got \(error)")
                return
            }
            XCTAssertTrue(validationError.message.contains("Expected string"))
        }
    }

    // MARK: - SafeParse Success

    func testSafeParseSuccessWithWrappedValue() {
        let schema = Z.optional(Z.number())
        let result = schema.safeParse(99.9)

        switch result {
        case let .success(value):
            XCTAssertEqual(value, 99.9)
        case let .failure(error):
            XCTFail("Expected success, got failure: \(error.message)")
        }
    }

    // MARK: - SafeParse Failure

    func testSafeParseFailureForInvalidType() {
        let schema = Z.optional(Z.number())
        let result = schema.safeParse("invalid")

        switch result {
        case let .failure(error):
            XCTAssertTrue(error.message.contains("Expected number"))
        case let .success(value):
            XCTFail("Expected failure, got success with \(String(describing: value))")
        }
    }

    func testOptionalWithinObjectSchemaNilKey() {
        let schema = Z.object([
            "title": Z.optional(Z.string()),
        ])

        let maybeNil: Any? = nil
        let object: [String: Any] = ["title": maybeNil as Any]

        XCTAssertNoThrow(try schema.parse(object))
    }
}
