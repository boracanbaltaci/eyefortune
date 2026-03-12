import SwiftUI

struct DynamicEyeView: View {
    let hexColor: String
    let colorName: String
    @ObservedObject var themeManager: ThemeManager
    
    @State private var animateGlow = false
    @State private var animateIris = false
    
    private var irisColor: Color {
        Color(hex: hexColor)
    }
    
    var body: some View {
        ZStack {
            // 1. Inner Glow
            Circle()
                .fill(RadialGradient(
                    gradient: Gradient(colors: [irisColor.opacity(0.4), Color.clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 70
                ))
                .scaleEffect(animateGlow ? 1.2 : 1.0)
                .opacity(animateGlow ? 0.6 : 0.4)
            
            // 2. Iris Base
            Circle()
                .fill(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            irisColor.opacity(0.8),
                            irisColor.opacity(0.4),
                            irisColor,
                            irisColor.opacity(0.6),
                            irisColor.opacity(0.8)
                        ]),
                        center: .center
                    )
                )
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(animateIris ? 360 : 0))
            
            // 3. Iris Texture (Simplified)
            Circle()
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [.white.opacity(0.2), .clear, .white.opacity(0.1), .clear]),
                        center: .center
                    ),
                    lineWidth: 2
                )
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(animateIris ? -360 : 0))
            
            // 4. Pupil
            Circle()
                .fill(Color.black)
                .frame(width: 40, height: 40)
                .shadow(color: irisColor.opacity(0.3), radius: 10)
            
            // 5. Specular Reflection
            Circle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 15, height: 15)
                .offset(x: -25, y: -25)
                .blur(radius: 2)
            
            // 6. Outer Border
            Circle()
                .stroke(themeManager.accentYellow.opacity(0.3), lineWidth: 1)
                .frame(width: 144, height: 144)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateGlow = true
            }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                animateIris = true
            }
        }
    }
}
