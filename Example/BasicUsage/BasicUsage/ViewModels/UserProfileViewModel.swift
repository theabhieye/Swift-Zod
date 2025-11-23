//
//  UserProfileViewModel.swift
//  BasicUsage
//
//  Created by Abhishek kapoor on 23/11/25.
//

import Foundation
import SwiftUI
import SwiftZod
import Combine

final class UserProfileViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded(UserProfile)
        case error(String)
    }

    @Published private(set) var state: State = .idle

    private let apiClient: APIClient

    init(apiClient: APIClient = MockAPIClient()) {
        self.apiClient = apiClient
    }

    @MainActor
    func load(valid: Bool) {
        state = .loading

        Task {
            do {
                let data = try await apiClient.fetchUserProfile(valid: valid)
                let user = try UserProfile.decodeAndValidate(
                    from: data,
                    schema: UserProfile.schema
                )
                state = .loaded(user)
            } catch let ve as ValidationError {
                // 🚨 Zod-style validation failure
                state = .error(ve.formattedDescription)
            } catch {
                // Other decoding / network errors
                state = .error(error.localizedDescription)
            }
        }
    }
}
