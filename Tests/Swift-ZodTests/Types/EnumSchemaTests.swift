//
//  EnumSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import Swift_Zod
import XCTest

final class EnumSchemaTests: XCTestCase {
    func testValidEnumValue() throws {
        let Size = Z.enum(["small", "medium", "large"])
        XCTAssertEqual(try Size.parse("medium"), "medium")
    }

    func testInvalidType() {
        let Size = Z.enum(["small", "medium", "large"])
        XCTAssertThrowsError(try Size.parse(123)) { error in
            XCTAssertEqual(
                error as? ValidationError,
                ValidationError("Expected string enum, got Int")
            )
        }
    }

    func testInvalidEnumValue() {
        let Size = Z.enum(["small", "medium", "large"])
        XCTAssertThrowsError(try Size.parse("extra")) { error in
            XCTAssertEqual(
                error as? ValidationError,
                ValidationError("Expected one of [\"small\", \"medium\", \"large\"], got 'extra'.")
            )
        }
    }

    func testSafeParseSuccess() {
        let Status = Z.enum(["active", "inactive"])
        let result = Status.safeParse("active")

        XCTAssertEqual(result, .success("active"))
    }

    func testSafeParseFailure() {
        let Status = Z.enum(["active", "inactive"])
        let result = Status.safeParse("deleted")

        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case let .failure(err):
            XCTAssertTrue(err.message.contains("Expected one of"))
        }
    }

    func testNonStringValueThrowsValidationError() {
        let Colors = Z.enum(["red", "green", "blue"])

        XCTAssertThrowsError(try Colors.parse(true)) { error in
            guard let validationError = error as? ValidationError else {
                return XCTFail("Expected ValidationError, got \(error)")
            }

            XCTAssertEqual(
                validationError,
                ValidationError("Expected string enum, got Bool")
            )
        }
    }
}
