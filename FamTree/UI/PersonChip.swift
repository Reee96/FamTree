import SwiftUI

struct PersonChip: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.callout.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.55), lineWidth: 0.9))
            .shadow(color: .black.opacity(0.28), radius: 12, x: 0, y: 8)
    }
}
