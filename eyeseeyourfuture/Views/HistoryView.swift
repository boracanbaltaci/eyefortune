import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var fortuneViewModel: FortuneViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager

    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)

                if fortuneViewModel.savedFortunes.isEmpty {
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
                        LazyVStack(spacing: 20) {
                            ForEach(fortuneViewModel.savedFortunes) { fortune in
                                FavoriteFortuneCard(fortune: fortune, themeManager: themeManager)
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle(lm.t(.historyTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct FavoriteFortuneCard: View {
    let fortune: Fortune
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(themeManager.accentYellow)
                
                Spacer()
                
                Text(fortune.dateGenerated, style: .date)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.6))
            }
            
            Text(fortune.text)
                .font(.system(size: 15, weight: .medium, design: .serif))
                .foregroundColor(themeManager.primaryTextColor)
                .lineSpacing(4)
                .lineLimit(4)
            
            HStack {
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(themeManager.accentYellow)
            }
        }
        .padding(20)
        .background(themeManager.cardBgColor)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(themeManager.accentYellow.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    HistoryView()
        .environmentObject(FortuneViewModel())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
