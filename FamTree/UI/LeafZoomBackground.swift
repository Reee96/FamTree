import SwiftUI

struct LeafZoomBackground: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.26, blue: 0.16),
                        Color(red: 0.14, green: 0.36, blue: 0.22),
                        Color(red: 0.19, green: 0.46, blue: 0.28)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                RadialGradient(
                    colors: [Color.white.opacity(0.08), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: min(w, h) * 0.8
                )
                .blendMode(.softLight)

                LeafClusterLayer(count: 180)
                    .opacity(0.35)
            }
        }
    }
}
