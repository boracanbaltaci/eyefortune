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
    @StateObject private var localizationManager = LocalizationManager()
    @StateObject private var storeManager = StoreManager()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var authManager = AuthManager()
    @StateObject private var fortuneViewModel = FortuneViewModel()
    
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
                    .environmentObject(authManager)
                    .environmentObject(fortuneViewModel)
                } else if authManager.user != nil && isSetupComplete {
                    MainTabView()
                        .environmentObject(themeManager)
                        .environmentObject(localizationManager)
                        .environmentObject(storeManager)
                        .environmentObject(authManager)
                        .environmentObject(fortuneViewModel)
                        .preferredColorScheme(themeManager.systemColorScheme)
                } else {
                    LoginView()
                        .environmentObject(themeManager)
                        .environmentObject(localizationManager)
                        .environmentObject(storeManager)
                        .environmentObject(authManager)
                        .environmentObject(fortuneViewModel)
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

