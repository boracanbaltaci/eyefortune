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
            // Background with mystic gradient and sparkles
            themeManager.bgColor.edgesIgnoringSafeArea(.all)
            
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(themeManager.accentYellow.opacity(0.05))
                        .frame(width: geo.size.width * 1.5)
                        .offset(y: -geo.size.height * 0.4)
                    
                    VStack(spacing: 0) {
                        // Custom Header
                        HStack {
                            Button(action: {
                                if isSaved {
                                    fortuneViewModel.savedFortunes.removeAll(where: { $0.id == fortune.id })
                                } else {
                                    fortuneViewModel.savedFortunes.append(fortune)
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(themeManager.cardBgColor)
                                        .frame(width: 40, height: 40)
                                        .shadow(color: Color.black.opacity(0.2), radius: 4)
                                    
                                    Image(systemName: isSaved ? "heart.fill" : "heart")
                                        .foregroundColor(isSaved ? .red : themeManager.accentYellow)
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
                            
                            Spacer()
                            
                            Text(fortune.type == .aiScan ? "Kişilik Analizi" : "Günlük Fal")
                                .font(.system(size: 16, weight: .bold, design: .serif))
                                .foregroundColor(themeManager.accentYellow)
                            
                            Spacer()
                            
                            Button(action: { dismiss() }) {
                                ZStack {
                                    Circle()
                                        .fill(themeManager.cardBgColor)
                                        .frame(width: 40, height: 40)
                                        .shadow(color: Color.black.opacity(0.2), radius: 4)
                                    
                                    Image(systemName: "xmark")
                                        .foregroundColor(themeManager.primaryTextColor)
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 30) {
                                // Mystic Icon
                                ZStack {
                                    Circle()
                                        .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: fortune.type == .aiScan ? "brain.head.profile" : "sparkles")
                                        .font(.system(size: 50))
                                        .foregroundColor(themeManager.accentYellow)
                                        .shadow(color: themeManager.accentYellow.opacity(0.5), radius: 10)
                                }
                                .padding(.top, 40)
                                
                                // Content Card
                                VStack(alignment: .leading, spacing: 20) {
                                    HStack {
                                        Text(fortune.dateGenerated, style: .date)
                                            .font(.system(size: 12, weight: .bold))
                                            .tracking(2)
                                            .foregroundColor(themeManager.accentYellow.opacity(0.7))
                                        Spacer()
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 10))
                                            .foregroundColor(themeManager.accentYellow)
                                    }
                                    
                                    Text(fortune.text)
                                        .font(.system(size: 18, weight: .medium, design: .serif))
                                        .lineSpacing(8)
                                        .foregroundColor(themeManager.primaryTextColor)
                                        .multilineTextAlignment(.leading)
                                    
                                    HStack {
                                        Spacer()
                                        Image(systemName: "sparkles")
                                            .foregroundColor(themeManager.accentYellow.opacity(0.3))
                                    }
                                }
                                .padding(30)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(themeManager.cardBgColor)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(themeManager.accentYellow.opacity(0.1), lineWidth: 1)
                                        )
                                )
                                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                                .padding(.horizontal, 20)
                                
                                // Inspirational Quote
                                Text("Evrenin fısıltılarını dinle, kalbinin sesini takip et.")
                                    .font(.system(size: 13, design: .serif))
                                    .italic()
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .padding(.bottom, 40)
                            }
                        }
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
