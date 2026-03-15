import SwiftUI

struct DynamicEyeView: View {
    let hexColor: String
    let colorName: String
    @ObservedObject var themeManager: ThemeManager
    
    @State private var pulseEffect = 1.0
    @State private var rotationDegree = 0.0
    @State private var animateGlow = false
    
    private var irisColor: Color {
        Color(hex: hexColor)
    }
    
    var body: some View {
        ZStack {
            scleraShadow
            limbalRing
            irisView
            iridialFibers // Added sharp fibers layer
            cryptsAndFurrows
            pupilView
            reflections
            corneaGlow
        }
        .scaleEffect(pulseEffect)
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                pulseEffect = 1.05
                animateGlow = true
            }
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                rotationDegree = 360
            }
        }
    }
    
    // MARK: - Subviews
    
    private var scleraShadow: some View {
        Circle()
            .fill(RadialGradient(
                gradient: Gradient(colors: [irisColor.opacity(0.3), Color.clear]),
                center: .center,
                startRadius: 50,
                endRadius: 75
            ))
            .scaleEffect(animateGlow ? 1.08 : 1.0)
    }
    
    private var limbalRing: some View {
        Circle()
            .stroke(irisColor.opacity(0.8), lineWidth: 5)
            .frame(width: 122, height: 122)
            .blur(radius: 1.5)
    }
    
    private var irisView: some View {
        Group {
            // Strong Background Color
            Circle()
                .fill(irisColor.opacity(0.95))
            
            // Depth Gradient
            Circle()
                .fill(RadialGradient(
                    gradient: Gradient(colors: [irisColor.opacity(0.8), irisColor.opacity(0.4), .black.opacity(0.3)]),
                    center: .center,
                    startRadius: 5,
                    endRadius: 60
                ))
            
            // Vibrancy layer to pop the color
            Circle()
                .fill(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            irisColor.opacity(0.6),
                            irisColor,
                            irisColor.opacity(0.4),
                            irisColor,
                            irisColor.opacity(0.6)
                        ]),
                        center: .center
                    )
                )
                .blendMode(.screen)
                .opacity(0.7)
        }
        .frame(width: 120, height: 120)
        .rotationEffect(.degrees(rotationDegree))
    }
    
    private var iridialFibers: some View {
        ZStack {
            ForEach(0..<60) { i in
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white.opacity(0.15), irisColor.opacity(0.4), .clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 1, height: CGFloat.random(in: 35...50))
                    .offset(y: -30)
                    .rotationEffect(.degrees(Double(i) * 6))
            }
            
            ForEach(0..<40) { i in
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.black.opacity(0.2), .clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 0.5, height: CGFloat.random(in: 20...40))
                    .offset(y: -35)
                    .rotationEffect(.degrees(Double(i) * 9 + 4))
            }
        }
        .frame(width: 120, height: 120)
        .rotationEffect(.degrees(rotationDegree * 0.5))
    }
    
    private var cryptsAndFurrows: some View {
        Circle()
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [.black.opacity(0.15), .clear, .black.opacity(0.08), .clear]),
                    center: .center
                ),
                lineWidth: 18
            )
            .frame(width: 75, height: 75)
            .blur(radius: 4)
    }
    
    private var pupilView: some View {
        Circle()
            .fill(Color.black)
            .frame(width: 44, height: 44)
            .overlay(
                Circle()
                    .stroke(irisColor.opacity(0.35), lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.7), radius: 6, x: 0, y: 0)
            .scaleEffect(pulseEffect > 1 ? 0.98 : 1.0)
    }
    
    private var reflections: some View {
        Group {
            // Main Highlight
            Circle()
                .fill(Color.white.opacity(0.6))
                .frame(width: 20, height: 16)
                .offset(x: -24, y: -24)
                .rotationEffect(.degrees(-15))
                .blur(radius: 1)
            
            // Secondary Soft Glow
            Circle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 35, height: 35)
                .offset(x: -18, y: -18)
                .blur(radius: 6)
            
            // Tiny Sparkle
            Circle()
                .fill(Color.white.opacity(0.8))
                .frame(width: 5, height: 5)
                .offset(x: -32, y: -22)
        }
    }
    
    private var corneaGlow: some View {
        Circle()
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: [.white.opacity(0.3), .clear, .white.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.5
            )
            .frame(width: 144, height: 144)
    }
}
