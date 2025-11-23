//
//  ContentView.swift
//  BasicUsage
//
//  Created by Abhishek kapoor on 23/11/25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserProfileViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Controls
                VStack(spacing: 12) {
                    Button("Load VALID Response") {
                        viewModel.load(valid: true)
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Load INVALID Response") {
                        viewModel.load(valid: false)
                    }
                    .buttonStyle(.bordered)
                }

                // State renderer
                Group {
                    switch viewModel.state {
                    case .idle:
                        Text("Tap one of the buttons to load data.")
                            .foregroundStyle(.secondary)

                    case .loading:
                        ProgressView("Loading from mock backend...")
                            .padding()

                    case .loaded(let user):
                        ProfileCardView(user: user)

                    case .error(let message):
                        ErrorCardView(message: message) {
                            // Retry last as VALID for simplicity
                            viewModel.load(valid: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                Spacer()
            }
            .padding()
            .navigationTitle("SwiftZod Demo")
        }
    }
}

