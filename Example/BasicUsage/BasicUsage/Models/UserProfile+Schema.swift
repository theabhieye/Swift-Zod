//
//  UserProfile+Schema.swift
//  BasicUsage
//
//  Created by Abhishek kapoor on 23/11/25.
//

import SwiftZod

extension UserProfile {
    // Zod-style schema for runtime validation
    static var schema: ObjectSchema {
        Z.object([
            "id": Z.string().uuid(),
            "name": Z.string().min(2),
            "email": Z.string().email(),
            "age": Z.number().min(18).max(120),
            "isActive": Z.boolean(),
        ])
    }
}
