//
//  PulsatingAvatar.swift
//  Maps SwiftUI vs UIKit
//
//  Created by Cleo Howard on 8/25/25.
//


import SwiftUI

struct PulsatingAvatar: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                .frame(width: 44, height: 44)
                .scaleEffect(animate ? 1.6 : 1)
                .opacity(animate ? 0 : 0.6)
                .animation(
                    .easeOut(duration: 1.5).repeatForever(autoreverses: false),
                    value: animate
                )

            Circle()
                .fill(Color.blue)
                .frame(width: 24, height: 24)
                .overlay(Text("👶").font(.caption))
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    PulsatingAvatar()
}
