//
//  StringSchemaCommonValidatorsTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import SwiftZod
import XCTest

final class StringSchemaCommonValidatorsTests: XCTestCase {
    // MARK: - Email

    func testEmailValidation() {
        let schema = Z.string().email()
        XCTAssertNoThrow(try schema.parse("user@example.com"))
        XCTAssertThrowsError(try schema.parse("invalid-email"))
    }

    // MARK: - UUID

    func testUUIDValidation() {
        let schema = Z.string().uuid()
        XCTAssertNoThrow(try schema.parse("123e4567-e89b-12d3-a456-426614174000"))
        XCTAssertThrowsError(try schema.parse("not-a-uuid"))
    }

    // MARK: - Phone

    func testPhoneValidation() {
        let schema = Z.string().phone()
        XCTAssertNoThrow(try schema.parse("+919876543210"))
        XCTAssertNoThrow(try schema.parse("9876543210"))
        XCTAssertThrowsError(try schema.parse("12a45"))
    }

    // MARK: - Alphanumeric

    func testAlphanumericValidation() {
        let schema = Z.string().alphanumeric()
        XCTAssertNoThrow(try schema.parse("Abhishek123"))
        XCTAssertThrowsError(try schema.parse("Abhishek!"))
    }

    // MARK: - URL

    func testURLValidation() {
        let schema = Z.string().url()
        XCTAssertNoThrow(try schema.parse("https://www.apple.com"))
        XCTAssertThrowsError(try schema.parse("ftp://example.com"))
        XCTAssertThrowsError(try schema.parse("invalid-url"))
    }

    func testURLValidationWithCustomSchemes() {
        let schema = Z.string().url(allowedSchemes: ["http", "https", "myapp"])
        XCTAssertNoThrow(try schema.parse("myapp://dashboard"))
        XCTAssertThrowsError(try schema.parse("ftp://server"))
    }
}
