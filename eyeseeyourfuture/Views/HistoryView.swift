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
                    VStack {
                        Image(systemName: "tray")
                            .font(.system(size: 50))
                            .foregroundColor(themeManager.secondaryTextColor)
                            .padding(.bottom, 10)
                        Text(lm.t(.historyEmpty))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                } else {
                    List {
                        ForEach(fortuneViewModel.savedFortunes) { fortune in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(fortune.type.rawValue)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(5)
                                        .background(fortune.type == .aiScan ? themeManager.accentYellow.opacity(0.3) : themeManager.secondaryTextColor.opacity(0.3))
                                        .cornerRadius(5)
                                        .foregroundColor(themeManager.primaryTextColor)

                                    Spacer()

                                    Text(fortune.dateGenerated, style: .date)
                                        .font(.caption)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }

                                Text(fortune.text)
                                    .font(.subheadline)
                                    .foregroundColor(themeManager.primaryTextColor)
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 5)
                            .listRowBackground(themeManager.cardBgColor)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle(lm.t(.historyTitle))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(FortuneViewModel())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
