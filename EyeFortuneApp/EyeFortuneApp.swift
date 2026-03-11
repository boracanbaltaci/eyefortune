import SwiftUI

@main
struct EyeFortuneApp: App {
    // Shared instances for state management
    @StateObject private var fortuneViewModel = FortuneViewModel()
    @StateObject private var scannerViewModel = ScannerViewModel()
    @StateObject private var themeManager = ThemeManager()
    
    @AppStorage("isSetupComplete") var isSetupComplete: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isSetupComplete {
                MainTabView()
                    .environmentObject(fortuneViewModel)
                    .environmentObject(scannerViewModel)
                    .environmentObject(themeManager)
                    .preferredColorScheme(themeManager.systemColorScheme)
            } else {
                LoginView()
                    .environmentObject(themeManager)
                    // You'll need access to these in the main app if LoginView directly changes it
                    .preferredColorScheme(themeManager.systemColorScheme)
            }
        }
    }
}
