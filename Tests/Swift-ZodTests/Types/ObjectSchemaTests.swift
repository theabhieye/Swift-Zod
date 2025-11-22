//
//  ObjectSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import Swift_Zod
import XCTest

final class ObjectSchemaTests: XCTestCase {
    // MARK: - Success Case

    func testValidObject() throws {
        let Player = Z.object([
            "username": Z.string().min(3),
            "xp": Z.number().min(0),
        ])

        let result = try Player.parse(["username": "Abhi", "xp": 100])

        XCTAssertEqual(result["username"] as? String, "Abhi")
        XCTAssertEqual(result["xp"] as? Double, 100)
    }

    // MARK: - Type and Missing Field Validation

    func testInvalidType() {
        let schema = Z.object(["name": Z.string()])

        XCTAssertThrowsError(try schema.parse("NotADictionary")) { error in
            XCTAssertEqual(
                error as? ValidationError,
                ValidationError("Expected object, got String")
            )
        }
    }

    func testMissingField() {
        let schema = Z.object([
            "name": Z.string(),
            "age": Z.number(),
        ])

        XCTAssertThrowsError(try schema.parse(["name": "Abhi"]))
    }

    // MARK: - Nested Schema Validation

    func testNestedValidationFailure() {
        let schema = Z.object([
            "name": Z.string(),
            "score": Z.number().min(50),
        ])

        XCTAssertThrowsError(try schema.parse(["name": "Abhi", "score": 10])) { error in
            guard let err = error as? ValidationError else {
                XCTFail("Expected ValidationError"); return
            }

            XCTAssertTrue(err.message.contains("[ObjectSchemaError]"))
            XCTAssertTrue(err.message.contains("score"))
        }
    }

    // MARK: - SafeParse Behavior

    func testSafeParseSuccess() {
        let schema = Z.object(["flag": Z.boolean()])
        let result = schema.safeParse(["flag": true])

        switch result {
        case let .success(dict):
            // Value type is [String: Any], cast before asserting
            XCTAssertEqual(dict["flag"] as? Bool, true)
        case let .failure(error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }

    func testSafeParseFailure() {
        let schema = Z.object(["age": Z.number()])
        let result = schema.safeParse(["age": "Invalid"])

        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case let .failure(err):
            XCTAssertTrue(
                err.message.contains("[ObjectSchemaError]"),
                "Expected [ObjectSchemaError] but got: \(err.message)"
            )
        }
    }
}
