import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(white: 0, alpha: 0.05)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(lm.t(.tabHome), systemImage: "sparkles")
                }

            ReadingView()
                .tabItem {
                    Label(lm.t(.tabReading), systemImage: "book.fill")
                }

            ScannerView()
                .tabItem {
                    Label(lm.t(.tabScan), systemImage: "eye.circle.fill")
                }

            HistoryView()
                .tabItem {
                    Label(lm.t(.tabHistory), systemImage: "clock.arrow.circlepath")
                }

            SettingsView()
                .tabItem {
                    Label(lm.t(.tabSettings), systemImage: "gearshape")
                }
        }
        .accentColor(themeManager.accentYellow)
    }
}

#Preview {
    MainTabView()
        .environmentObject(FortuneViewModel())
        .environmentObject(ScannerViewModel())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
