//
//  CoerceSchemaTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

// CoerceSchemaEdgeCasesTests.swift
// Swift-Zod Tests
//
// Created by ChatGPT

@testable import Swift_Zod
import XCTest

final class CoerceSchemaEdgeCasesTests: XCTestCase {
    // MARK: - Number coercion (happy paths)

    func test_coerce_number_from_string_with_decimal() throws {
        let schema = Z.coerce.number()
        XCTAssertEqual(try schema.parse("42.5"), 42.5)
    }

    func test_coerce_number_from_scientific_notation() throws {
        let schema = Z.coerce.number()
        XCTAssertEqual(try schema.parse("1e3"), 1000.0)
    }

    func test_coerce_number_from_plus_and_minus_strings() throws {
        let schema = Z.coerce.number()
        XCTAssertEqual(try schema.parse("+3"), 3.0)
        XCTAssertEqual(try schema.parse("-2"), -2.0)
    }

    func test_coerce_number_from_whitespace_string() throws {
        let schema = Z.coerce.number()
        // Double(" 7 ") is valid
        XCTAssertEqual(try schema.parse(" 7 "), 7.0)
    }

    // MARK: - Number coercion (failure paths)

    func test_coerce_number_from_empty_string_throws() {
        let schema = Z.coerce.number()
        XCTAssertThrowsError(try schema.parse("")) { error in
            guard let ve = error as? ValidationError else {
                return XCTFail("Expected ValidationError")
            }
            XCTAssertTrue(ve.message.contains("CoerceSchemaError") || ve.message.contains("Failed to coerce"))
        }
    }

    func test_coerce_number_from_non_numeric_string_throws() {
        let schema = Z.coerce.number()
        XCTAssertThrowsError(try schema.parse("notANumber"))
    }

    func test_coerce_number_from_nsnull_throws() {
        let schema = Z.coerce.number()
        XCTAssertThrowsError(try schema.parse(NSNull()))
    }

    // MARK: - Boolean coercion (happy paths)

    func test_coerce_boolean_various_strings_and_ints() throws {
        let schema = Z.coerce.boolean()
        XCTAssertTrue(try schema.parse("true"))
        XCTAssertTrue(try schema.parse("True")) // case-insensitive
        XCTAssertTrue(try schema.parse("YES"))
        XCTAssertTrue(try schema.parse("y"))
        XCTAssertTrue(try schema.parse(1))
        XCTAssertTrue(try schema.parse(2)) // any non-zero int -> true

        XCTAssertFalse(try schema.parse("false"))
        XCTAssertFalse(try schema.parse("0"))
        XCTAssertFalse(try schema.parse("no"))
        XCTAssertFalse(try schema.parse("n"))
        XCTAssertFalse(try schema.parse(0))
    }

    // MARK: - Boolean coercion (failure)

    func test_coerce_boolean_invalid_string_throws() {
        let schema = Z.coerce.boolean()
        XCTAssertThrowsError(try schema.parse("maybe")) { error in
            guard let ve = error as? ValidationError else {
                return XCTFail("Expected ValidationError")
            }
            XCTAssertTrue(ve.message.contains("CoerceSchemaError") || ve.message.contains("Failed to coerce"))
        }
    }

    func test_coerce_boolean_from_nsnull_throws() {
        let schema = Z.coerce.boolean()
        XCTAssertThrowsError(try schema.parse(NSNull()))
    }

    // MARK: - String coercion

    func test_coerce_string_from_int_double_bool() throws {
        let schema = Z.coerce.string()
        XCTAssertEqual(try schema.parse(123), "123")
        XCTAssertEqual(try schema.parse(12.5), "12.5")
        XCTAssertEqual(try schema.parse(true), "true")
    }

    func test_coerce_string_from_array_and_dictionary() throws {
        let schema = Z.coerce.string()
        let arr = [1, 2, 3]
        let dict: [String: Any] = ["a": 1]
        // String(describing:) should produce representations for these
        XCTAssertEqual(try schema.parse(arr), String(describing: arr))
        XCTAssertEqual(try schema.parse(dict), String(describing: dict))
    }

    // MARK: - Coercion then base-parse failure (coercion succeeded but underlying schema rejects)

    func test_coercion_succeeds_but_base_parse_fails_reports_coerce_error() {
        // Create a CoerceSchema with a base number schema that requires positive values.
        let coercer: (Any) -> Any? = { value in
            if let s = value as? String, let d = Double(s) { return d }
            if let i = value as? Int { return Double(i) }
            return nil
        }
        let schema = CoerceSchema(base: Z.number().positive(), coercer: coercer)

        XCTAssertThrowsError(try schema.parse("-5")) { error in
            guard let ve = error as? ValidationError else {
                return XCTFail("Expected ValidationError")
            }
            XCTAssertTrue(ve.message.contains("CoerceSchemaError"), "expected CoerceSchemaError but got: \(ve.message)")
            // underlying message should indicate positive requirement
            XCTAssertTrue(ve.message.contains("Expected a positive number") || ve.message.contains("positive"))
        }
    }

    // MARK: - safeParse behavior

    func test_safeParse_returns_failure_for_invalid_coercion() {
        let schema = Z.coerce.number()
        let result = schema.safeParse("not-a-number")
        switch result {
        case .success:
            XCTFail("Expected failure")
        case let .failure(ve):
            XCTAssertTrue(ve.message.contains("CoerceSchemaError") || ve.message.contains("Failed to coerce"))
        }
    }

    func test_safeParse_success_for_valid_coercion() {
        let schema = Z.coerce.boolean()
        let result = schema.safeParse("yes")
        switch result {
        case let .success(b):
            XCTAssertEqual(b, true)
        case let .failure(ve):
            XCTFail("Expected success but got failure: \(ve.message)")
        }
    }
}
