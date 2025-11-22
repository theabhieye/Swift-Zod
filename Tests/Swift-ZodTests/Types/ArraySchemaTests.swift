//
//  ArraySchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import Swift_Zod
import XCTest

final class ArraySchemaTests: XCTestCase {
    func testValidStringArray() throws {
        let schema = Z.array(Z.string())
        let result = try schema.parse(["A", "B", "C"])
        XCTAssertEqual(result, ["A", "B", "C"])
    }

    func testInvalidType() {
        let schema = Z.array(Z.string())
        XCTAssertThrowsError(try schema.parse("NotAnArray")) { error in
            XCTAssertEqual(error as? ValidationError,
                           ValidationError("Expected array, got String"))
        }
    }

    func testElementValidationFailure() {
        let schema = Z.array(Z.string())
        XCTAssertThrowsError(try schema.parse(["A", 123, "C"])) { error in
            guard let err = error as? ValidationError else {
                XCTFail("Expected ValidationError"); return
            }
            XCTAssertTrue(err.message.contains("[ArraySchemaError]"))
            XCTAssertTrue(err.message.contains("index 1"))
        }
    }

    func testMinMaxValidation() {
        let schema = Z.array(Z.number()).min(2).max(4)
        XCTAssertNoThrow(try schema.parse([1, 2, 3]))
        XCTAssertThrowsError(try schema.parse([1])) { error in
            XCTAssertEqual(error as? ValidationError,
                           ValidationError("[ArraySchemaError] Expected at least 2 elements but got 1."))
        }
        XCTAssertThrowsError(try schema.parse([1, 2, 3, 4, 5])) { error in
            XCTAssertEqual(error as? ValidationError,
                           ValidationError("[ArraySchemaError] Expected at most 4 elements but got 5."))
        }
    }

    func testNestedValidation() {
        let schema = Z.array(Z.number().min(0))
        XCTAssertNoThrow(try schema.parse([1, 2, 3]))
        XCTAssertThrowsError(try schema.parse([1, -5, 3])) { error in
            guard let err = error as? ValidationError else {
                XCTFail("Expected ValidationError"); return
            }
            XCTAssertTrue(err.message.contains("[ArraySchemaError]"))
            XCTAssertTrue(err.message.contains("index 1"))
        }
    }

    func testSafeParseSuccess() {
        let schema = Z.array(Z.number())
        let result = schema.safeParse([1, 2, 3])
        XCTAssertEqual(result, .success([1, 2, 3]))
    }

    func testSafeParseFailure() {
        let schema = Z.array(Z.number())
        let result = schema.safeParse("oops")
        XCTAssertEqual(result, .failure(ValidationError("Expected array, got String")))
    }
}
