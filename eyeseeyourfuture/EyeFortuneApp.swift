import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct EyeFortuneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Shared instances for state management
    @StateObject private var authManager = AuthManager()
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
                } else if authManager.user != nil && isSetupComplete {
                    MainTabView()
                        .environmentObject(authManager)
                        .environmentObject(fortuneViewModel)
                        .environmentObject(scannerViewModel)
                        .environmentObject(themeManager)
                        .environmentObject(localizationManager)
                        .preferredColorScheme(themeManager.systemColorScheme)
                } else {
                    LoginView()
                        .environmentObject(authManager)
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

