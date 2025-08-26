//
//  ClusterStackView.swift
//  Maps SwiftUI vs UIKit
//
//  Created by Cleo Howard on 8/25/25.
//

import SwiftUI

struct ClusterBubbleView: View {
    let initials: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 3) {
                ForEach(initials.prefix(3), id: \.self) { initial in
                    Text(initial)
                        .font(.caption).bold()
                        .foregroundColor(.black)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.white))
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                
                if initials.count > 3 {
                    Text("+\(initials.count - 3)")
                        .font(.caption2).bold()
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)
            .padding(.bottom, 4)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
            )
            
            // Tail (arrow)
            Triangle()
                .fill(Color.white)
                .frame(width: 12, height: 6)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            
            PulsatingAvatar(color: .blue, emoji: "")
        }
    }
}

#Preview {
    ClusterBubbleView(initials: ["A", "T", "T", "N", "K"])
        .padding()
        .background(Color(.systemBackground))
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))    // Bottom center
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // Top right
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // Top left
            path.closeSubpath()
        }
    }
}
