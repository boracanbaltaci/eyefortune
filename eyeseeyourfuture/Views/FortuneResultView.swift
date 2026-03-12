import SwiftUI

struct FortuneResultView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var fortuneViewModel: FortuneViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    let fortune: Fortune

    var isSaved: Bool {
        fortuneViewModel.savedFortunes.contains(where: { $0.id == fortune.id })
    }

    var body: some View {
        ZStack {
            // Background with mystic gradient
            themeManager.bgColor.edgesIgnoringSafeArea(.all)
            
            GeometryReader { geo in
                VStack(spacing: 0) {
                    // Custom Header (Fixed at top)
                    HStack {
                        Color.clear.frame(width: 44, height: 44)
                        
                        Spacer()
                        
                        Text("Eye See : Fortune")
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
                        VStack(spacing: 24) {
                            Spacer(minLength: 10)
                            
                            // Mystic Icon Header
                            ZStack {
                                Circle()
                                    .stroke(themeManager.accentYellow.opacity(0.15), lineWidth: 1)
                                    .frame(width: 130, height: 130)
                                
                                Circle()
                                    .fill(themeManager.accentYellow.opacity(0.05))
                                    .frame(width: 110, height: 110)
                                
                                Image(systemName: fortune.type == .aiScan ? "brain.head.profile" : "sparkles")
                                    .font(.system(size: 54))
                                    .foregroundColor(themeManager.accentYellow)
                                    .shadow(color: themeManager.accentYellow.opacity(0.5), radius: 15)
                            }
                            
                            // Content Card
                            VStack(alignment: .leading, spacing: 24) {
                                HStack {
                                    Text(fortune.dateGenerated, style: .date)
                                        .font(.system(size: 12, weight: .black))
                                        .tracking(2)
                                        .foregroundColor(themeManager.accentYellow.opacity(0.6))
                                    if fortune.type != .aiScan {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 10))
                                            .foregroundColor(themeManager.accentYellow.opacity(0.5))
                                    }
                                }
                                
                                Text(fortune.text)
                                    .font(.system(size: 19, weight: .medium, design: .serif))
                                    .lineSpacing(10)
                                    .foregroundColor(themeManager.primaryTextColor)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                            }
                            .padding(32)
                            .background(
                                RoundedRectangle(cornerRadius: 32)
                                    .fill(themeManager.cardBgColor)
                                    .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 15)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(themeManager.accentYellow.opacity(0.15), lineWidth: 1)
                            )
                            .padding(.horizontal, 24)
                            
                            // Motivational Footer
                            VStack(spacing: 8) {
                                Text("KOZMİK REHBER")
                                    .font(.system(size: 10, weight: .black))
                                    .tracking(2)
                                    .foregroundColor(themeManager.accentYellow.opacity(0.5))
                                
                                Text("Evrenin fısıltılarını dinle, kalbinin sesini takip et.")
                                    .font(.system(size: 14, weight: .medium, design: .serif))
                                    .italic()
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.bottom, 60)
                            
                            Spacer(minLength: 20)
                        }
                        .frame(minHeight: geo.size.height - 100) // Ensure it fills space for centering
                    }
                }
            }
        }
    }
}

#Preview {
    FortuneResultView(fortune: Fortune(text: "Bu bir test falıdır.", dateGenerated: Date(), type: .aiScan))
        .environmentObject(FortuneViewModel())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
