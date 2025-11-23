//
//  ProfileCardView.swift
//  BasicUsage
//
//  Created by Abhishek kapoor on 23/11/25.
//

import SwiftUI

struct ProfileCardView: View {
    let user: UserProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(user.name)
                    .font(.title2).bold()
                Spacer()
                Circle()
                    .fill(user.isActive ? .green.opacity(0.2) : .red.opacity(0.2))
                    .frame(width: 12, height: 12)
            }

            Text(user.email)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Label("Age: \(user.age)", systemImage: "person.fill")
                Spacer()
                Label(user.isActive ? "Active" : "Inactive",
                      systemImage: user.isActive ? "checkmark.seal.fill" : "xmark.seal.fill")
            }
            .font(.subheadline)

        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 4)
    }
}
