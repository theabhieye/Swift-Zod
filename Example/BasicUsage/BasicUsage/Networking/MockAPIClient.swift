//
//  MockAPIClient.swift
//  BasicUsage
//
//  Created by Abhishek kapoor on 23/11/25.
//

import Foundation

final class MockAPIClient: APIClient {
    func fetchUserProfile(valid: Bool) async throws -> Data {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 800_000_000) // 0.8s

        if valid {
            // ✅ Valid JSON that passes SwiftZod schema
            let json = """
            {
                "id": "b6b3a9b2-2a4c-4b88-8c1a-9b6b4b9d4c4a",
                "name": "Abhishek Kapoor",
                "email": "abhishek@example.com",
                "age": 27,
                "isActive": true
            }
            """
            return Data(json.utf8)
        } else {
            // ❌ Intentionally invalid JSON for demo:
            // - age is < 18
            // - email is invalid
            // - extra field "unknownField"
            let json = """
            {
                "id": "not-a-uuid",
                "name": "A",
                "email": "invalid-email",
                "age": 15,
                "isActive": true,
                "unknownField": "should fail if you make schema strict later"
            }
            """
            return Data(json.utf8)
        }
    }
}
