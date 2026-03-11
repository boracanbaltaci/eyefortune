import SwiftUI

@main
struct EyeFortuneApp: App {
    // Shared instances for state management
    @StateObject private var fortuneViewModel = FortuneViewModel()
    @StateObject private var scannerViewModel = ScannerViewModel()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var localizationManager = LocalizationManager()
    
    @AppStorage("isSetupComplete") var isSetupComplete: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isSetupComplete {
                MainTabView()
                    .environmentObject(fortuneViewModel)
                    .environmentObject(scannerViewModel)
                    .environmentObject(themeManager)
                    .environmentObject(localizationManager)
                    .preferredColorScheme(themeManager.systemColorScheme)
            } else {
                LoginView()
                    .environmentObject(themeManager)
                    .environmentObject(localizationManager)
                    .preferredColorScheme(themeManager.systemColorScheme)
            }
        }
    }
}

