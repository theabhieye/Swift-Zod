//
//  ErrorCardView.swift
//  BasicUsage
//
//  Created by Abhishek kapoor on 23/11/25.
//

import SwiftUI

struct ErrorCardView: View {
    let message: String
    var onRetry: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                Text("Validation Error")
                    .font(.headline)
            }
            .foregroundStyle(.red)

            ScrollView {
                Text(message)
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(minHeight: 60, maxHeight: 160)

            Button("Retry with valid response", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 4)
    }
}
