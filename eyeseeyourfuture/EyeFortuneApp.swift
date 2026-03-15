import SwiftUI

@main
struct EyeFortuneApp: App {
    // Shared instances for state management
    @StateObject private var fortuneViewModel = FortuneViewModel()
    @StateObject private var scannerViewModel = ScannerViewModel()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var localizationManager = LocalizationManager()
    
    @AppStorage("isSetupComplete") var isSetupComplete: Bool = false
    @State private var isSplashFinished = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !isSplashFinished {
                    SplashScreenView(onFinished: {
                        isSplashFinished = true
                    })
                    .environmentObject(themeManager)
                } else if isSetupComplete {
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
            .onAppear {
                NotificationManager.shared.requestAuthorization()
                NotificationManager.shared.updateLastOpenDate()
            }
        }
    }
}

