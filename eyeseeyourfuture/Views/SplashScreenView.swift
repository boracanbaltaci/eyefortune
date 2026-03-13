import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var onFinished: () -> Void
    
    @State private var startAnimation = false
    @State private var eyeOpacity = 0.0
    @State private var eyeScale: CGFloat = 0.8
    @State private var textOpacity = 0.0
    @State private var textOffset: CGFloat = 20
    
    // Sparkle particles
    @State private var particleOpacities: [Double] = Array(repeating: 0.0, count: 20)
    @State private var particleOffsets: [CGSize] = (0..<20).map { _ in 
        CGSize(width: CGFloat.random(in: -150...150), height: CGFloat.random(in: -150...150)) 
    }
    
    var body: some View {
        ZStack {
            themeManager.bgColor.edgesIgnoringSafeArea(.all)
            
            // Sparkling Background Particles
            ForEach(0..<20, id: \.self) { index in
                Image(systemName: index % 2 == 0 ? "sparkle" : "sparkles")
                    .foregroundColor(themeManager.accentYellow.opacity(particleOpacities[index]))
                    .font(.system(size: CGFloat.random(in: 10...24)))
                    .offset(particleOffsets[index])
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 1.0...2.5))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...1.5)),
                        value: particleOpacities[index]
                    )
            }
            
            VStack(spacing: 30) {
                // Central Glowing Eye
                ZStack {
                    // Outer Glow
                    Circle()
                        .fill(themeManager.accentYellow.opacity(0.15))
                        .frame(width: 160, height: 160)
                        .blur(radius: 20)
                        .scaleEffect(startAnimation ? 1.2 : 0.8)
                    
                    Circle()
                        .stroke(themeManager.accentYellow.opacity(0.3), lineWidth: 1)
                        .frame(width: 140, height: 140)
                    
                    Image(systemName: "eye.fill")
                        .font(.system(size: 80))
                        .foregroundColor(themeManager.accentYellow)
                        .shadow(color: themeManager.accentYellow.opacity(0.6), radius: 20)
                }
                .opacity(eyeOpacity)
                .scaleEffect(eyeScale)
                
                // App Name
                VStack(spacing: 8) {
                    Text("Eye see")
                        .font(.system(size: 40, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    
                    Text("FORTUNE")
                        .font(.system(size: 14, weight: .black))
                        .tracking(8)
                        .foregroundColor(themeManager.accentYellow)
                }
                .opacity(textOpacity)
                .offset(y: textOffset)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                eyeOpacity = 1.0
                eyeScale = 1.0
                startAnimation = true
            }
            
            withAnimation(.easeOut(duration: 1.0).delay(0.5)) {
                textOpacity = 1.0
                textOffset = 0
            }
            
            // Activate particles
            for i in 0..<20 {
                particleOpacities[i] = Double.random(in: 0.3...0.8)
            }
            
            // Finish after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    onFinished()
                }
            }
        }
    }
}

#Preview {
    SplashScreenView(onFinished: {})
        .environmentObject(ThemeManager())
}
