import Foundation
import SwiftUI


struct DailyTheme: Identifiable, Codable {
    var id: String { nameKey.rawValue }
    let nameKey: LKey
    let symbol: String
    let colorHex: String
    
    var color: Color {
        Color(hex: colorHex)
    }
}

class DailyThemeManager {
    static let shared = DailyThemeManager()
    
    private let themes: [DailyTheme] = [
        DailyTheme(nameKey: .themeLove, symbol: "heart.fill", colorHex: "#FF4B91"),
        DailyTheme(nameKey: .themeFriendship, symbol: "person.2.fill", colorHex: "#2ECC71"),
        DailyTheme(nameKey: .themeFamily, symbol: "house.fill", colorHex: "#FFB000"),
        DailyTheme(nameKey: .themePeace, symbol: "leaf.fill", colorHex: "#65B741"),
        DailyTheme(nameKey: .themeAnxiety, symbol: "cloud.bolt.rain.fill", colorHex: "#7077A1"),
        DailyTheme(nameKey: .themeExcitement, symbol: "sparkles", colorHex: "#FF004D"),
        DailyTheme(nameKey: .themeSports, symbol: "figure.run", colorHex: "#FBA834"),
        DailyTheme(nameKey: .themeEntertainment, symbol: "party.popper.fill", colorHex: "#9D44C0"),
        DailyTheme(nameKey: .themeWork, symbol: "briefcase.fill", colorHex: "#40A2E3"),
        DailyTheme(nameKey: .themeEducation, symbol: "book.closed.fill", colorHex: "#535C91")
    ]
    
    func currentTheme() -> DailyTheme {
        // Use calendar day to pick a theme
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayOfYear % themes.count
        return themes[index]
    }
    
    func theme(at index: Int) -> DailyTheme {
        let safeIndex = max(0, min(index, themes.count - 1))
        return themes[safeIndex]
    }
    
    var allThemes: [DailyTheme] {
        return themes
    }
}

