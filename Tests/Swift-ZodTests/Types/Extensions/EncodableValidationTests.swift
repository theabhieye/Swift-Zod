//
//  EncodableValidationTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import Swift_Zod
import XCTest

final class EncodableValidationTests: XCTestCase {
    // MARK: - Test Model

    struct User: Codable, Equatable {
        let id: String
        let email: String
        let age: Int
        let isActive: Bool
    }

    // MARK: - Schema Definition

    private var userSchema: ObjectSchema {
        Z.object([
            "id": Z.string().uuid(),
            "email": Z.string().email(),
            "age": Z.number().min(18).max(120),
            "isActive": Z.boolean(),
        ])
    }

    // MARK: - Positive Case

    func testEncodableValidationSuccess() throws {
        let user = User(
            id: "b6b3a9b2-2a4c-4b88-8c1a-9b6b4b9d4c4a",
            email: "john.doe@example.com",
            age: 25,
            isActive: true
        )

        XCTAssertNoThrow(try user.validate(with: userSchema))
    }

    // MARK: - Negative Cases

    func testEncodableValidationFailure_invalidEmail() throws {
        let user = User(
            id: "b6b3a9b2-2a4c-4b88-8c1a-9b6b4b9d4c4a",
            email: "invalid-email",
            age: 25,
            isActive: true
        )

        XCTAssertThrowsError(try user.validate(with: userSchema)) { error in
            guard let err = error as? ValidationError else {
                return XCTFail("Expected ValidationError")
            }
            XCTAssertTrue(err.message.contains("[StringSchemaError]"))
            XCTAssertTrue(err.message.contains("invalid-email"))
        }
    }

    func testEncodableValidationFailure_ageTooLow() throws {
        let user = User(
            id: "b6b3a9b2-2a4c-4b88-8c1a-9b6b4b9d4c4a",
            email: "john@example.com",
            age: 12,
            isActive: true
        )

        XCTAssertThrowsError(try user.validate(with: userSchema)) { error in
            guard let err = error as? ValidationError else {
                return XCTFail("Expected ValidationError")
            }
            XCTAssertTrue(err.message.contains("Expected number ≥ 18"))
        }
    }

    func testEncodableValidationFailure_invalidUUID() throws {
        let user = User(
            id: "not-a-uuid",
            email: "john@example.com",
            age: 22,
            isActive: false
        )

        XCTAssertThrowsError(try user.validate(with: userSchema)) { error in
            guard let err = error as? ValidationError else {
                return XCTFail("Expected ValidationError")
            }
            XCTAssertTrue(err.message.contains("[StringSchemaError]"))
            XCTAssertTrue(err.message.contains("not-a-uuid"))
        }
    }

    func testEncodableValidationFailure_multipleInvalidFields() throws {
        let user = User(
            id: "not-a-uuid",
            email: "bad-email",
            age: 10,
            isActive: true
        )

        XCTAssertThrowsError(try user.validate(with: userSchema)) { error in
            guard let err = error as? ValidationError else {
                return XCTFail("Expected ValidationError")
            }
            XCTAssertTrue(err.message.contains("[StringSchemaError]") || err.message.contains("Expected number ≥"))
        }
    }

    // MARK: - Edge Case

    func testEncodableValidationFailure_encodingError() throws {
        struct BrokenUser: Encodable {
            let invalidValue: Double = .nan
        }

        let brokenUser = BrokenUser()

        XCTAssertThrowsError(try brokenUser.validate(with: userSchema))
    }
}
