import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    init() {
        // Customize TabBar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(white: 0, alpha: 0.05) // Transparent enough to let the background show slightly, but readable
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "sparkles")
                }
            
            ScannerView()
                .tabItem {
                    Label("Scan Eye", systemImage: "eye.circle.fill")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
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
}
