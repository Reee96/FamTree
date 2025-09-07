import SwiftUI

struct RootView: View {
    @State private var started = false

    var body: some View {
        ZStack {
            if started {
                FamilyTreeScreen()
                    .transition(.opacity.combined(with: .scale))
            } else {
                StartScreen { withAnimation(.easeInOut(duration: 0.6)) { started = true } }
                    .transition(.opacity)
            }
        }
    }
}
