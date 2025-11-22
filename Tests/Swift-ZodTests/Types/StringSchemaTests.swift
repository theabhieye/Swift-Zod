//
//  StringSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import Swift_Zod
import XCTest

final class StringSchemaTests: XCTestCase {
    // MARK: - Type Validation

    func testValidString() throws {
        let schema = Z.string()
        XCTAssertEqual(try schema.parse("Hello"), "Hello")
    }

    func testInvalidType() {
        let schema = Z.string()
        XCTAssertThrowsError(try schema.parse(123)) { error in
            XCTAssertEqual(
                error as? ValidationError,
                ValidationError("Expected string, got Int")
            )
        }
    }

    // MARK: - Length Validation

    func testMinValidation() {
        let schema = Z.string().min(3)
        XCTAssertNoThrow(try schema.parse("Hey"))

        XCTAssertThrowsError(try schema.parse("Hi")) { error in
            XCTAssertEqual(
                error as? ValidationError,
                ValidationError("[StringSchemaError] Expected at least 3 characters but got 2.")
            )
        }
    }

    func testMaxValidation() {
        let schema = Z.string().max(5)
        XCTAssertNoThrow(try schema.parse("Hello"))

        XCTAssertThrowsError(try schema.parse("Welcome")) { error in
            XCTAssertEqual(
                error as? ValidationError,
                ValidationError("[StringSchemaError] Expected at most 5 characters but got 7.")
            )
        }
    }

    // MARK: - Regex Validation

    func testRegexValidation() {
        let schema = Z.string().matches("^[A-Z]+$")
        XCTAssertNoThrow(try schema.parse("ABC"))

        XCTAssertThrowsError(try schema.parse("abc")) { error in
            guard let err = error as? ValidationError else {
                XCTFail("Expected ValidationError"); return
            }
            XCTAssertTrue(err.message.contains("[StringSchemaError]"))
            XCTAssertTrue(err.message.contains("does not match pattern"))
            XCTAssertTrue(err.message.contains("^[A-Z]+$"))
        }
    }

    // MARK: - SafeParse Tests

    func testSafeParseSuccess() {
        let schema = Z.string()
        let result = schema.safeParse("Hello")
        XCTAssertEqual(result, .success("Hello"))
    }

    func testSafeParseFailure() {
        let schema = Z.string()
        let result = schema.safeParse(42)
        XCTAssertEqual(result, .failure(ValidationError("Expected string, got Int")))
    }
}
