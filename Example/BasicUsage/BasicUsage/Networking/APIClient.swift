//
//  APIClient.swift
//  BasicUsage
//
//  Created by Abhishek kapoor on 23/11/25.
//

import Foundation

enum APIError: Error {
    case invalidResponse
}

protocol APIClient {
    func fetchUserProfile(valid: Bool) async throws -> Data
}
