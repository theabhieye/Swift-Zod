//
//  NumberSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import Swift_Zod
import XCTest

final class NumberSchemaTests: XCTestCase {
    func testValidNumber() throws {
        let schema = Z.number()
        XCTAssertEqual(try schema.parse(42), 42)
        XCTAssertEqual(try schema.parse(42.5), 42.5)
    }

    func testInvalidType() {
        let schema = Z.number()
        XCTAssertThrowsError(try schema.parse("Hello")) { error in
            XCTAssertEqual(error as? ValidationError, ValidationError("Expected number, got String"))
        }
    }

    func testMinValidation() {
        let schema = Z.number().min(10)
        XCTAssertNoThrow(try schema.parse(10))
        XCTAssertNoThrow(try schema.parse(12))
        XCTAssertThrowsError(try schema.parse(5)) { error in
            XCTAssertEqual(error as? ValidationError, ValidationError("Expected number ≥ 10.0 but got 5.0"))
        }
    }

    func testMaxValidation() {
        let schema = Z.number().max(100)
        XCTAssertNoThrow(try schema.parse(99))
        XCTAssertThrowsError(try schema.parse(120)) { error in
            XCTAssertEqual(error as? ValidationError, ValidationError("Expected number ≤ 100.0 but got 120.0"))
        }
    }

    func testPositiveValidation() {
        let schema = Z.number().positive()
        XCTAssertNoThrow(try schema.parse(1))
        XCTAssertThrowsError(try schema.parse(-3)) { error in
            XCTAssertEqual(error as? ValidationError, ValidationError("Expected a positive number but got -3.0"))
        }
    }

    func testNegativeValidation() {
        let schema = Z.number().negative()
        XCTAssertNoThrow(try schema.parse(-1))
        XCTAssertThrowsError(try schema.parse(2)) { error in
            XCTAssertEqual(error as? ValidationError, ValidationError("Expected a negative number but got 2.0"))
        }
    }

    func testSafeParseSuccess() {
        let schema = Z.number()
        let result = schema.safeParse(42)
        XCTAssertEqual(result, .success(42))
    }

    func testSafeParseFailure() {
        let schema = Z.number()
        let result = schema.safeParse("Hi")
        XCTAssertEqual(result, .failure(ValidationError("Expected number, got String")))
    }
}
