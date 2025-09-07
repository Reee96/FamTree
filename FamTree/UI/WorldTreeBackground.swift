import SwiftUI

// MARK: - 世界樹 背景レイヤー一式
/// スタート画面の背景を描画するメインビュー。
/// 夜空・月・大樹（幹/樹冠/枝）・演出（星・後光・光の柱・薄靄・ビネット）を重ねて荘厳さを表現。
struct WorldTreeBackground: View {
    /// 画面サイズに応じて各レイヤーを配置・描画する。
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                // 空（縦グラデ）
                LinearGradient(colors: [
                    Color(red: 0.06, green: 0.10, blue: 0.15),
                    Color(red: 0.11, green: 0.18, blue: 0.26),
                    Color(red: 0.17, green: 0.28, blue: 0.36)
                ], startPoint: .top, endPoint: .bottom)
                .overlay(EnhancedStarfieldLayer(density: 140).blendMode(.screen)) // 星の層
                .overlay(MoonLayer().blendMode(.screen)) // 月

                // 地面のアーチ
                RoundedRectangle(cornerRadius: h * 0.10)
                    .fill(LinearGradient(colors: [
                        Color(red: 0.11, green: 0.22, blue: 0.13),
                        Color(red: 0.10, green: 0.18, blue: 0.11)
                    ], startPoint: .top, endPoint: .bottom))
                    .frame(height: h * 0.26)
                    .position(x: w * 0.5, y: h * 0.94)

                // 幹（下ほど太く、根張り）
                WorldTreeTrunk()
                    .fill(LinearGradient(colors: [
                        Color(red: 0.22, green: 0.16, blue: 0.11),
                        Color(red: 0.30, green: 0.22, blue: 0.16)
                    ], startPoint: .bottom, endPoint: .top))
                    .frame(width: w, height: h)
                    .shadow(color: .black.opacity(0.4), radius: 24, x: 0, y: 14)

                // 樹のシルエット枝（奥行き）
                BranchSilhouetteLayer().frame(width: w, height: h).opacity(0.35)

                // 樹冠（ボリュームのあるグリーン）
                WorldCanopy(scale: 1.30, x:  0.00, y: -h * 0.18, opacity: 0.98)
                WorldCanopy(scale: 1.08, x: -w * 0.14, y: -h * 0.15, opacity: 0.92)
                WorldCanopy(scale: 1.10, x:  w * 0.16, y: -h * 0.15, opacity: 0.92)
                WorldCanopy(scale: 0.96, x: -w * 0.25, y: -h * 0.10, opacity: 0.88)
                WorldCanopy(scale: 0.98, x:  w * 0.26, y: -h * 0.10, opacity: 0.88)
                WorldCanopy(scale: 0.82, x:  0.00,      y: -h * 0.04, opacity: 0.82)

                // ※中央の落ち葉の層（LeafClusterLayer）はデザイン簡素化のため削除してもOK
                LeafClusterLayer(count: 260).opacity(0.65)

                // 後光・光の柱・薄靄（神々しさの演出）
                SacredHaloLayer()
                    .frame(width: w, height: h)
                    .blendMode(.screen)
                    .opacity(0.45)

                LightShaftsLayer()
                    .frame(width: w, height: h)
                    .blendMode(.screen)
                    .opacity(0.35)

                LowMistLayer()
                    .frame(width: w, height: h)
                    .opacity(0.25)

                // ゴッドレイ（中心強調）
                RadialGradient(colors: [Color.white.opacity(0.24), .clear],
                               center: .init(x: 0.5, y: 0.30),
                               startRadius: 0, endRadius: min(w, h) * 0.65)
                    .blendMode(.softLight)

                // 周辺減光（中央に視線を集める）
                VignetteOverlay()
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - 後光
/// 樹冠付近に柔らかな光のハローを描く。
struct SacredHaloLayer: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            RadialGradient(
                colors: [
                    Color.white.opacity(0.35),
                    Color.white.opacity(0.12),
                    .clear
                ],
                center: .init(x: 0.5, y: 0.25),
                startRadius: 0,
                endRadius: min(w, h) * 0.75
            )
            .blur(radius: 20)
        }
    }
}

// MARK: - 光の柱
/// 上空から降り注ぐ複数の薄い光柱で神秘感を高める。
struct LightShaftsLayer: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                ForEach(0..<7, id: \.self) { i in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.12), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: w * 0.02, height: h * 0.55)
                        .position(x: w * 0.5, y: h * 0.32)
                        .rotationEffect(.degrees(Double(i - 3) * 7.5))
                        .blur(radius: 6)
                }
            }
        }
    }
}

// MARK: - 薄靄
/// 地表近くに薄く漂う靄で奥行きと神秘性を付与。
struct LowMistLayer: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            VStack {
                Spacer()
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.15), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: w * 1.2, height: h * 0.25)
                    .blur(radius: 18)
                    .offset(y: h * 0.05)
            }
        }
    }
}

// MARK: - ビネット
/// 画面外周をほんのり暗くして中心の樹を強調。
struct VignetteOverlay: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            RadialGradient(
                colors: [
                    .clear,
                    Color.black.opacity(0.18),
                    Color.black.opacity(0.32)
                ],
                center: .center,
                startRadius: min(w, h) * 0.55,
                endRadius: min(w, h) * 0.96
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - 幹
/// 世界樹の幹。下部ほど太く、根張りを含むシルエットを描く。
struct WorldTreeTrunk: Shape {
    /// 幹の輪郭パスを返す。
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.26, y: h * 0.95))
        p.addCurve(to: CGPoint(x: w * 0.40, y: h * 0.42), control1: CGPoint(x: w * 0.18, y: h * 0.82), control2: CGPoint(x: w * 0.34, y: h * 0.50))
        p.addCurve(to: CGPoint(x: w * 0.18, y: h * 0.22), control1: CGPoint(x: w * 0.46, y: h * 0.30), control2: CGPoint(x: w * 0.26, y: h * 0.24))
        p.addQuadCurve(to: CGPoint(x: w * 0.36, y: h * 0.28), control: CGPoint(x: w * 0.26, y: h * 0.20))
        p.addCurve(to: CGPoint(x: w * 0.74, y: h * 0.42), control1: CGPoint(x: w * 0.52, y: h * 0.32), control2: CGPoint(x: w * 0.66, y: h * 0.36))
        p.addCurve(to: CGPoint(x: w * 0.78, y: h * 0.95), control1: CGPoint(x: w * 0.86, y: h * 0.66), control2: CGPoint(x: w * 0.82, y: h * 0.88))
        p.addCurve(to: CGPoint(x: w * 0.64, y: h * 0.96), control1: CGPoint(x: w * 0.76, y: h * 0.98), control2: CGPoint(x: w * 0.70, y: h * 0.99))
        p.addCurve(to: CGPoint(x: w * 0.50, y: h * 0.97), control1: CGPoint(x: w * 0.60, y: h * 0.94), control2: CGPoint(x: w * 0.54, y: h * 0.96))
        p.addCurve(to: CGPoint(x: w * 0.36, y: h * 0.96), control1: CGPoint(x: w * 0.46, y: h * 0.98), control2: CGPoint(x: w * 0.42, y: h * 0.99))
        p.addCurve(to: CGPoint(x: w * 0.26, y: h * 0.95), control1: CGPoint(x: w * 0.32, y: h * 0.94), control2: CGPoint(x: w * 0.28, y: h * 0.95))
        p.closeSubpath()
        return p
    }
}

// MARK: - 樹冠
/// 広がる樹冠とハイライトの楕円群で葉のボリュームを演出。
struct WorldCanopy: View {
    var scale: CGFloat
    var x: CGFloat = 0
    var y: CGFloat
    var opacity: CGFloat
    /// 楕円の塗りとハイライト群を重ねて樹冠を描く。
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                Ellipse()
                    .fill(LinearGradient(colors: [
                        Color(red: 0.25, green: 0.50, blue: 0.30),
                        Color(red: 0.16, green: 0.34, blue: 0.23)
                    ], startPoint: .top, endPoint: .bottom))
                    .frame(width: w * 0.98 * scale, height: h * 0.44 * scale)
                    .position(x: w * 0.50 + x, y: h * 0.28 + y)
                    .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 12)
                ForEach(0..<16, id: \.self) { i in
                    Ellipse()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: w * (0.020 + 0.010 * CGFloat(i % 3)) * scale,
                               height: h * (0.012 + 0.008 * CGFloat(i % 3)) * scale)
                        .position(x: w * (0.22 + CGFloat(i) * 0.055) * scale + x + w * 0.24,
                                  y: h * (0.17 + CGFloat(i % 4) * 0.032) * scale + y + h * 0.12)
                        .rotationEffect(.degrees(Double(i) * 9))
                }
            }
            .opacity(opacity)
        }
    }
}

// MARK: - 細かな葉クラスタ
/// ランダムな小楕円で微細な葉の重なりテクスチャを生成。
struct LeafClusterLayer: View {
    let count: Int
    /// Canvas 上にランダム位置/色/サイズの葉を描画する。
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            Canvas { ctx, _ in
                for _ in 0..<count {
                    let sx = CGFloat.random(in: w * 0.18...w * 0.82)
                    let sy = CGFloat.random(in: h * 0.10...h * 0.45)
                    let rw = CGFloat.random(in: 6...22)
                    let rh = rw * CGFloat.random(in: 0.5...0.9)
                    let hue = Double.random(in: 0.30...0.38)
                    let sat = Double.random(in: 0.40...0.65)
                    let bri = Double.random(in: 0.28...0.45)
                    let alpha = Double.random(in: 0.30...0.65)
                    let color = Color(hue: hue, saturation: sat, brightness: bri, opacity: alpha)
                    ctx.fill(Path(ellipseIn: CGRect(x: sx, y: sy, width: rw, height: rh)), with: .color(color))
                }
            }
        }
    }
}

// MARK: - 枝のシルエット
/// 細い曲線で暗い枝を散らし、奥行きとシルエット感を付与。
struct BranchSilhouetteLayer: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            Canvas { ctx, _ in
                let strokes = 16
                for _ in 0..<strokes {
                    var path = Path()
                    let startX = CGFloat.random(in: w * 0.45...w * 0.55)
                    let startY = CGFloat.random(in: h * 0.36...h * 0.46)
                    let endX = startX + CGFloat.random(in: -w * 0.38...w * 0.38)
                    let endY = startY - CGFloat.random(in: h * 0.06...h * 0.18)
                    let c1 = CGPoint(x: (startX + endX) / 2 + CGFloat.random(in: -60...60), y: startY - CGFloat.random(in: 40...120))
                    let c2 = CGPoint(x: (startX + endX) / 2 + CGFloat.random(in: -60...60), y: startY - CGFloat.random(in: 60...140))
                    path.move(to: CGPoint(x: startX, y: startY))
                    path.addCurve(to: CGPoint(x: endX, y: endY), control1: c1, control2: c2)
                    let lineWidth = CGFloat.random(in: 1.0...3.0)
                    ctx.stroke(path, with: .color(Color(red: 0.10, green: 0.17, blue: 0.12).opacity(0.70)), lineWidth: lineWidth)
                }
            }
        }
    }
}

// MARK: - 月
/// 右上に柔らかいグラデの月と小さなクレーターを描く。
struct MoonLayer: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [
                        Color.white.opacity(0.95),
                        Color.white.opacity(0.75)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: min(w, h) * 0.16, height: min(w, h) * 0.16)
                    .position(x: w * 0.78, y: h * 0.18)
                    .shadow(color: .white.opacity(0.35), radius: 24)
                ForEach(0..<6, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.22))
                        .frame(width: CGFloat(8 + i * 2), height: CGFloat(8 + i * 2))
                        .position(x: w * (0.74 + CGFloat(i) * 0.015), y: h * (0.17 + CGFloat(i % 3) * 0.02))
                }
            }
        }
    }
}

// MARK: - 星空
/// 夜空に細かな星と細い横方向のきらめきを散りばめる。
struct EnhancedStarfieldLayer: View {
    let density: Int
    /// Canvasでランダムな白点（星）と短い線（瞬き）を描く。
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            Canvas { ctx, _ in
                // stars
                for _ in 0..<density {
                    let x = CGFloat.random(in: 0...w)
                    let y = CGFloat.random(in: 0...(h * 0.55))
                    let r = CGFloat.random(in: 0.7...1.8)
                    let alpha = Double.random(in: 0.25...0.6)
                    ctx.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: r, height: r)),
                        with: .color(Color.white.opacity(alpha))
                    )
                }
                // twinkles
                for _ in 0..<10 {
                    let x = CGFloat.random(in: 0...w)
                    let y = CGFloat.random(in: 0...(h * 0.5))
                    let len = CGFloat.random(in: 10...28)
                    var path = Path()
                    path.move(to: CGPoint(x: x - len/2, y: y))
                    path.addLine(to: CGPoint(x: x + len/2, y: y))
                    ctx.stroke(path, with: .color(Color.white.opacity(0.35)), lineWidth: 0.6)
                }
            }
        }
    }
}
