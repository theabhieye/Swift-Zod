//
//  BooleanSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import SwiftZod
import XCTest

final class BooleanSchemaTests: XCTestCase {
    func testValidBoolean() throws {
        let schema = Z.boolean()
        XCTAssertEqual(try schema.parse(true), true)
        XCTAssertEqual(try schema.parse(false), false)
    }

    func testInvalidType() {
        let schema = Z.boolean()
        XCTAssertThrowsError(try schema.parse("true")) { error in
            XCTAssertEqual(error as? ValidationError,
                           ValidationError("Expected boolean, got String"))
        }
    }

    func testTrueOnly() {
        let schema = Z.boolean().trueOnly()
        XCTAssertNoThrow(try schema.parse(true))
        XCTAssertThrowsError(try schema.parse(false)) { error in
            XCTAssertEqual(error as? ValidationError,
                           ValidationError("[BooleanSchemaError] Expected `true` but got `false`."))
        }
    }

    func testFalseOnly() {
        let schema = Z.boolean().falseOnly()
        XCTAssertNoThrow(try schema.parse(false))
        XCTAssertThrowsError(try schema.parse(true)) { error in
            XCTAssertEqual(error as? ValidationError,
                           ValidationError("[BooleanSchemaError] Expected `false` but got `true`."))
        }
    }

    func testSafeParseSuccess() {
        let schema = Z.boolean()
        let result = schema.safeParse(true)
        XCTAssertEqual(result, .success(true))
    }

    func testSafeParseFailure() {
        let schema = Z.boolean()
        let result = schema.safeParse("true")
        XCTAssertEqual(result, .failure(ValidationError("Expected boolean, got String")))
    }
}
