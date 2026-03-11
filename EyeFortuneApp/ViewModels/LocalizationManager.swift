import Foundation
import SwiftUI
import Combine

// MARK: - Supported Languages
enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case turkish    = "tr"
    case english    = "en"
    case french     = "fr"
    case spanish    = "es"
    case german     = "de"
    case italian    = "it"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .turkish:  return "Türkçe"
        case .english:  return "English"
        case .french:   return "Français"
        case .spanish:  return "Español"
        case .german:   return "Deutsch"
        case .italian:  return "Italiano"
        }
    }

    var flag: String {
        switch self {
        case .turkish:  return "🇹🇷"
        case .english:  return "🇬🇧"
        case .french:   return "🇫🇷"
        case .spanish:  return "🇪🇸"
        case .german:   return "🇩🇪"
        case .italian:  return "🇮🇹"
        }
    }
}

// MARK: - Localization Manager
@MainActor
class LocalizationManager: ObservableObject {
    @AppStorage("appLanguage") var languageCode: String = AppLanguage.turkish.rawValue {
        didSet { objectWillChange.send() }
    }

    var language: AppLanguage {
        get { AppLanguage(rawValue: languageCode) ?? .turkish }
        set { languageCode = newValue.rawValue }
    }

    /// Returns the localized string for a given key in the active language.
    func t(_ key: LKey) -> String {
        return LocalizedStrings.translations[language]?[key]
            ?? LocalizedStrings.translations[.english]?[key]
            ?? key.rawValue
    }
}
