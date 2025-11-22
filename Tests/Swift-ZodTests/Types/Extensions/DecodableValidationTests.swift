//
//  DecodableValidationTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import Swift_Zod
import XCTest

final class DecodableValidationTests: XCTestCase {
    // MARK: - Test Model

    struct User: Codable, Equatable {
        let id: String
        let email: String
        let age: Int
        let isActive: Bool
    }

    // MARK: - Schema

    private var userSchema: ObjectSchema {
        Z.object([
            "id": Z.string().uuid(),
            "email": Z.string().email(),
            "age": Z.number().min(18).max(120),
            "isActive": Z.boolean(),
        ])
    }

    // MARK: - Positive Case

    func testDecodeAndValidateSuccess() throws {
        let json = """
        {
            "id": "b6b3a9b2-2a4c-4b88-8c1a-9b6b4b9d4c4a",
            "email": "john.doe@example.com",
            "age": 30,
            "isActive": true
        }
        """.data(using: .utf8)!

        let user = try User.decodeAndValidate(from: json, schema: userSchema)
        XCTAssertEqual(user.email, "john.doe@example.com")
        XCTAssertEqual(user.age, 30)
        XCTAssertTrue(user.isActive)
    }

    // MARK: - Negative Cases

    func testDecodeAndValidateFailure_invalidEmail() throws {
        let json = """
        {
            "id": "b6b3a9b2-2a4c-4b88-8c1a-9b6b4b9d4c4a",
            "email": "invalid-email",
            "age": 25,
            "isActive": false
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try User.decodeAndValidate(from: json, schema: userSchema)) { error in
            guard let err = error as? ValidationError else {
                return XCTFail("Expected ValidationError")
            }
            XCTAssertTrue(err.message.contains("[StringSchemaError]"))
            XCTAssertTrue(err.message.contains("invalid-email"))
        }
    }

    func testDecodeAndValidateFailure_invalidUUID() throws {
        let json = """
        {
            "id": "not-a-uuid",
            "email": "john@example.com",
            "age": 25,
            "isActive": true
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try User.decodeAndValidate(from: json, schema: userSchema)) { error in
            guard let err = error as? ValidationError else {
                return XCTFail("Expected ValidationError")
            }
            XCTAssertTrue(err.message.contains("not-a-uuid"))
        }
    }

    func testDecodeAndValidateFailure_ageTooLow() throws {
        let json = """
        {
            "id": "b6b3a9b2-2a4c-4b88-8c1a-9b6b4b9d4c4a",
            "email": "john@example.com",
            "age": 12,
            "isActive": true
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try User.decodeAndValidate(from: json, schema: userSchema)) { error in
            guard let err = error as? ValidationError else {
                return XCTFail("Expected ValidationError")
            }
            XCTAssertTrue(err.message.contains("Expected number ≥ 18"))
        }
    }

    func testDecodeAndValidateFailure_missingField() throws {
        let json = """
        {
            "id": "b6b3a9b2-2a4c-4b88-8c1a-9b6b4b9d4c4a",
            "email": "john@example.com",
            "age": 25
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try User.decodeAndValidate(from: json, schema: userSchema))
    }

    func testDecodeAndValidateFailure_invalidJSON() throws {
        // Invalid JSON: missing closing brace
        let json = """
        {
            "id": "b6b3a9b2-2a4c-4b88-8c1a-9b6b4b9d4c4a",
            "email": "john@example.com",
            "age": 25,
            "isActive": true
        """.data(using: .utf8)!

        XCTAssertThrowsError(try User.decodeAndValidate(from: json, schema: userSchema)) { error in
            XCTAssertTrue(error.localizedDescription.contains("The data couldn’t be read"))
        }
    }

    // MARK: - Optional Schema Example

    func testDecodeAndValidateWithOptionalField() throws {
        struct Profile: Codable, Equatable {
            let username: String
            let bio: String?
        }

        let profileSchema = Z.object([
            "username": Z.string().min(3),
            "bio": Z.string().max(100).optional(),
        ])

        let json = """
        {
            "username": "swiftdev"
        }
        """.data(using: .utf8)!

        let profile = try Profile.decodeAndValidate(from: json, schema: profileSchema)
        XCTAssertEqual(profile.username, "swiftdev")
        XCTAssertNil(profile.bio)
    }
}
