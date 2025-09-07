import SwiftUI

struct StartScreen: View {
    let onStart: () -> Void

    var body: some View {
        ZStack {
            WorldTreeBackground().ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer().frame(height: 28)
                VStack(spacing: 10) {
                    Text("FamTree")
                        .font(.system(size: 48, weight: .bold, design: .serif))
                        .tracking(1.0)
                        .foregroundStyle(LinearGradient(colors: [Color.white, Color.white.opacity(0.85)], startPoint: .top, endPoint: .bottom))
                        .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 10)
                    Text("あなたのルーツを手の中に")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.92))
                        .shadow(radius: 6)
                }
                .padding(.top, 6)
                Spacer()
                Button(action: onStart) {
                    Text("スタート")
                        .font(.title3.weight(.semibold))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(
                            Capsule().fill(.ultraThinMaterial)
                                .overlay(Capsule().stroke(.white.opacity(0.65), lineWidth: 1))
                        )
                }
                .tint(.white)
                .shadow(color: .black.opacity(0.35), radius: 14, x: 0, y: 10)
                .padding(.bottom, 36)
            }
        }
    }
}
