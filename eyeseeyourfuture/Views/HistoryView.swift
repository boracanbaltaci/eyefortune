import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var fortuneViewModel: FortuneViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager

    @State private var selectedFortune: Fortune? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)

                if fortuneViewModel.savedFortunes.filter({ $0.type == .daily }).isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 80))
                            .foregroundColor(themeManager.accentYellow.opacity(0.2))
                        Text(lm.t(.historyEmpty))
                            .font(.system(size: 16, weight: .medium, design: .serif))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            // Magical Header
                            VStack(spacing: 12) {
                                Text(lm.t(.historyHeaderTitle)) // Updated header title
                                    .font(.system(size: 28, weight: .bold, design: .serif))
                                    .foregroundColor(themeManager.accentYellow)
                                
                                Text(lm.t(.historyHeaderSubtitle)) // Updated header subtitle
                                    .font(.system(size: 14, weight: .medium, design: .serif))
                                    .italic()
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                Rectangle()
                                    .fill(themeManager.accentYellow.opacity(0.3))
                                    .frame(width: 60, height: 1)
                                    .padding(.top, 8)
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 30)

                            LazyVStack(spacing: 20) {
                                ForEach(fortuneViewModel.savedFortunes.filter({ $0.type == .daily })) { fortune in
                                    FavoriteFortuneCard(fortune: fortune, themeManager: themeManager) {
                                        selectedFortune = fortune
                                    }
                                }
                            }
                            .padding(20)
                        }
                    }
                }
            }
            .navigationTitle("Gizli Defter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(item: $selectedFortune) { fortune in
                FortuneResultView(fortune: fortune)
                    .environmentObject(fortuneViewModel)
                    .environmentObject(themeManager)
                    .environmentObject(lm)
            }
        }
    }
}

struct FavoriteFortuneCard: View {
    let fortune: Fortune
    @ObservedObject var themeManager: ThemeManager
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 15) {
                // Top accent row
                HStack {
                    ZStack {
                        Circle()
                            .fill(themeManager.accentYellow.opacity(0.1))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: fortune.type == .aiScan ? "brain.head.profile" : "sparkles")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(themeManager.accentYellow)
                    }
                    
                    Text(fortune.type == .aiScan ? "Kişilik Analizi" : "Gelecek Okuması")
                        .font(.system(size: 11, weight: .black))
                        .tracking(1)
                        .foregroundColor(themeManager.accentYellow)
                    
                    Spacer()
                    
                    Text(fortune.dateGenerated, style: .date)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(themeManager.secondaryTextColor.opacity(0.6))
                }
                
                // Content preview
                Text(fortune.text)
                    .font(.system(size: 15, weight: .medium, design: .serif))
                    .foregroundColor(themeManager.primaryTextColor)
                    .lineSpacing(6)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Footer
                HStack {
                    Text("OKUMAYA DEVAM ET")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(themeManager.accentYellow.opacity(0.8))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(themeManager.accentYellow)
                }
                .padding(.top, 5)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(themeManager.cardBgColor)
                    .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [themeManager.accentYellow.opacity(0.3), .clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HistoryView()
        .environmentObject(FortuneViewModel())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
