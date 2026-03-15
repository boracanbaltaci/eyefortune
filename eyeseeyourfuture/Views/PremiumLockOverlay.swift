import SwiftUI

struct PremiumLockOverlay: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    
    var onSubscribe: () -> Void
    
    var body: some View {
        ZStack {
            // Blurred/Gradient Background to obscure content
            VStack {
                Spacer()
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        themeManager.bgColor.opacity(0.8),
                        themeManager.bgColor,
                        themeManager.bgColor
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 400)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Icon
                ZStack {
                    Circle()
                        .fill(themeManager.accentYellow.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(themeManager.accentYellow)
                }
                .shadow(color: themeManager.accentYellow.opacity(0.3), radius: 20, x: 0, y: 10)
                
                // Text
                VStack(spacing: 12) {
                    Text(lm.t(.premiumLockedTitle))
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                        .multilineTextAlignment(.center)
                    
                    Text(lm.t(.premiumLockedDesc))
                        .font(.system(size: 16))
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Button
                Button(action: onSubscribe) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text(lm.t(.premiumLockedButton))
                            .fontWeight(.bold)
                    }
                    .foregroundColor(themeManager.bgColor)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(themeManager.accentYellow)
                            .shadow(color: themeManager.accentYellow.opacity(0.4), radius: 10, x: 0, y: 5)
                    )
                }
                .padding(.bottom, 60)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        PremiumLockOverlay(onSubscribe: {})
            .environmentObject(ThemeManager())
            .environmentObject(LocalizationManager())
    }
}
