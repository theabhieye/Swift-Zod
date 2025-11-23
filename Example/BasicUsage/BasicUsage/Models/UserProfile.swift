//
//  UserProfile.swift
//  BasicUsage
//
//  Created by Abhishek kapoor on 23/11/25.
//

import Foundation

struct UserProfile: Codable, Equatable {
    let id: String
    let name: String
    let email: String
    let age: Int
    let isActive: Bool
}
