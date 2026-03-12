import SwiftUI
import Combine

enum AppTheme: String, CaseIterable, Identifiable {
    case midnight = "Midnight"
    case aurora = "Aurora (Light)"
    
    var id: String { self.rawValue }
}

class ThemeManager: ObservableObject {
    @Published var activeTheme: AppTheme = .midnight
    
    // Core Colors
    var bgColor: Color {
        activeTheme == .midnight ?
            Color(red: 34.0/255.0, green: 30.0/255.0, blue: 16.0/255.0) : // Updated to match #221e10 background-dark
            Color(red: 230.0/255.0, green: 207.0/255.0, blue: 169.0/255.0) // Matches #E6CFA9
    }
    
    var accentYellow: Color {
        if activeTheme == .midnight {
            // Matches #f4c025 (Primary Yellow)
            return Color(red: 244.0/255.0, green: 192.0/255.0, blue: 37.0/255.0)
        } else {
            // Matches #221e10 (Dark Discovery Color)
            return Color(red: 34.0/255.0, green: 30.0/255.0, blue: 16.0/255.0)
        }
    }
    
    // Input / Card Backgrounds
    var cardBgColor: Color {
        activeTheme == .midnight ?
            Color.white.opacity(0.05) : // Transparent white over dark
            Color.black.opacity(0.05)   // Transparent black over light
    }
    
    var inputBgColor: Color {
        activeTheme == .midnight ?
            Color.white.opacity(0.05) :
            Color.white // Solid white works better on #f8f8f5 light background
    }
    
    // Text Colors
    var primaryTextColor: Color {
        activeTheme == .midnight ? .white : Color(red: 15.0/255.0, green: 23.0/255.0, blue: 42.0/255.0) // slate-900
    }
    
    var secondaryTextColor: Color {
        activeTheme == .midnight ? Color(red: 148.0/255.0, green: 163.0/255.0, blue: 184.0/255.0) : // slate-400
                                   Color(red: 100.0/255.0, green: 116.0/255.0, blue: 139.0/255.0) // slate-500
    }
    
    var systemColorScheme: ColorScheme {
        activeTheme == .midnight ? .dark : .light
    }
    
    // Special Gradients for Heros
    var heroGradientTop: Color {
        activeTheme == .midnight ? Color.black : Color(red: 220/255.0, green: 230/255.0, blue: 245/255.0)
    }
    var heroGradientBottom: Color {
        activeTheme == .midnight ? Color(red: 30/255.0, green: 45/255.0, blue: 55/255.0) : Color.white
    }
}
