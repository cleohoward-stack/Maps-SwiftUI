//
//  PulsatingAvatar.swift
//  Maps SwiftUI vs UIKit
//
//  Created by Cleo Howard on 8/25/25.
//


import SwiftUI

struct PulsatingAvatar: View {
    var color: Color = .blue
    var emoji: String = "👶"
    var pulseSize: CGFloat = 44
    var iconSize: CGFloat = 24
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Pulsing ring
            Circle()
                .stroke(color.opacity(0.6), lineWidth: 2)
                .frame(width: pulseSize, height: pulseSize)
                .scaleEffect(animate ? 1.6 : 1)
                .opacity(animate ? 0 : 0.6)
                .animation(
                    .easeOut(duration: 1.5).repeatForever(autoreverses: false),
                    value: animate
                )
            
            // Core avatar
            Circle()
                .fill(color)
                .frame(width: iconSize, height: iconSize)
                .overlay(Text(emoji).font(.caption))
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    PulsatingAvatar() // default 👶 blue
    PulsatingAvatar(color: .green, emoji: "")
    PulsatingAvatar(color: .red, emoji: "❤️", pulseSize: 60, iconSize: 28)
}
