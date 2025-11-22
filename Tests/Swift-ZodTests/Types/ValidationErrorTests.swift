//
//  ValidationErrorTests.swift
//  Swift-Zod
//
//  Created by Abhishek kapoor on 09/11/25.
//

@testable import Swift_Zod
import XCTest

final class ValidationErrorTests: XCTestCase {
    func test_formatted_path_and_description() {
        let error = ValidationError("Expected string", path: ["name", "user"])
        XCTAssertEqual(error.formattedPath, "user.name")
        XCTAssertEqual(error.formattedDescription, "user.name: Expected string")
    }

    func test_formatted_description_without_path() {
        let error = ValidationError("Expected boolean")
        XCTAssertEqual(error.formattedDescription, "Expected boolean")
    }

    func test_description_matches_formatted() {
        let error = ValidationError("Invalid value", path: ["settings", "theme"])
        XCTAssertEqual(error.description, error.formattedDescription)
    }
}
