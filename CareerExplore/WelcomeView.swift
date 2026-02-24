//  WelcomeView.swift
//  CareerExplore
//
//  Created by Assistant on 2/23/26.

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome to CareerExplore")
                .font(.largeTitle)
                .bold()
            Text("Get started by exploring industries and roles.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Welcome")
    }
}

#Preview {
    NavigationStack { WelcomeView() }
}
