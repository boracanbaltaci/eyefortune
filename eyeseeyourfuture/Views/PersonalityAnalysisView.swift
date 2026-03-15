import SwiftUI

struct PersonalityAnalysisView: View {
    let text: String
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("isPremium") var isPremium = false
    @State private var showSubscription = false
    @EnvironmentObject var lm: LocalizationManager

    var body: some View {
        ZStack {
            themeManager.bgColor.ignoresSafeArea()
            
            // Glowing background aura
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [themeManager.accentYellow.opacity(0.15), .orange.opacity(0.05)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 400, height: 400)
                    .blur(radius: 60)
                    .offset(y: -100)
            }
            
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Color.clear.frame(width: 44, height: 44)
                    
                    Spacer()
                    
                    Text("Kişilik Analizin")
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.accentYellow)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        ZStack {
                            Circle()
                                .fill(themeManager.cardBgColor)
                                .frame(width: 44, height: 44)
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                            
                            Image(systemName: "xmark")
                                .foregroundColor(themeManager.primaryTextColor)
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .zIndex(10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Premium Header Icon
                        ZStack {
                            Circle()
                                .stroke(themeManager.accentYellow.opacity(0.15), lineWidth: 1.5)
                                .frame(width: 150, height: 150)
                            
                            Circle()
                                .fill(themeManager.accentYellow.opacity(0.08))
                                .frame(width: 130, height: 130)
                            
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 64))
                                .foregroundColor(themeManager.accentYellow)
                                .shadow(color: themeManager.accentYellow.opacity(0.5), radius: 20)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 24))
                                .foregroundColor(themeManager.accentYellow.opacity(0.6))
                                .offset(x: 45, y: -45)
                        }
                        .padding(.top, 40)
                        
                        // Content Card
                        VStack(alignment: .leading, spacing: 28) {
                            HStack {
                                Text("ANALİZ SONUCU")
                                    .font(.system(size: 13, weight: .black))
                                    .tracking(3)
                                    .foregroundColor(themeManager.accentYellow)
                                Spacer()
                            }
                            
                            Text(text)
                                .font(.system(size: 19, weight: .medium, design: .serif))
                                .lineSpacing(10)
                                .foregroundColor(themeManager.primaryTextColor)
                                .blur(radius: isPremium ? 0 : 12)
                            
                            // Advice / Guidance Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 8) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(themeManager.accentYellow)
                                        .font(.system(size: 14))
                                    Text("Senin için bir rehber")
                                        .font(.system(size: 10, weight: .black))
                                        .tracking(1)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }
                                
                                Text("Kendini keşfetme yolculuğun, evrenin sana sunduğu en değerli hazinedir. Bu analizdeki her bir cümle, içindeki potansiyeli uyandırmak için bir anahtardır.")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(themeManager.primaryTextColor)
                                    .padding(20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(themeManager.accentYellow.opacity(0.06))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                    .blur(radius: isPremium ? 0 : 4)
                            }
                        }
                        .padding(32)
                        .background(
                            RoundedRectangle(cornerRadius: 36)
                                .fill(themeManager.cardBgColor)
                                .shadow(color: Color.black.opacity(0.12), radius: 30, x: 0, y: 15)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [themeManager.accentYellow.opacity(0.3), .clear, themeManager.accentYellow.opacity(0.1)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .padding(.horizontal, 20)
                        
                        // Footer Message
                        HStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .foregroundColor(themeManager.accentYellow.opacity(0.6))
                            Text("Işığını parlatmaya devam et.")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                }
            }
            
            if !isPremium {
                PremiumLockOverlay(onSubscribe: {
                    showSubscription = true
                })
            }
        }
        .sheet(isPresented: $showSubscription) {
            SubscriptionView(shouldShowPersonalSetup: .constant(false))
                .environmentObject(themeManager)
                .environmentObject(lm)
        }
    }
}
