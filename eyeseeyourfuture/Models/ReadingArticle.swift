import Foundation

// MARK: - Reading Category
enum ReadingCategory: String, CaseIterable, Identifiable, Codable {
    case all           = "all"
    case meditation    = "meditation"
    case personality   = "personality"
    case development   = "development"
    case mindfulness   = "mindfulness"
    case wellness      = "wellness"
    case spiritualism  = "spiritualism"
    case astrology     = "astrology"

    var id: String { self.rawValue }

    func displayName(lm: LocalizationManager) -> String {
        switch self {
        case .all:          return lm.t(.readingCatAll)
        case .meditation:   return lm.t(.readingCatMed)
        case .personality:  return lm.t(.readingCatPers)
        case .development:  return lm.t(.readingCatDev)
        case .mindfulness:  return lm.t(.readingCatMind)
        case .wellness:     return lm.t(.readingCatWell)
        case .spiritualism: return lm.t(.readingCatSpir)
        case .astrology:    return lm.t(.readingCatAstro)
        }
    }

    var icon: String {
        switch self {
        case .all:          return "square.grid.2x2"
        case .meditation:   return "figure.mind.and.body"
        case .personality:  return "brain.head.profile"
        case .development:  return "chart.line.uptrend.xyaxis"
        case .mindfulness:  return "leaf"
        case .wellness:     return "heart.fill"
        case .spiritualism: return "moon.stars.fill"
        case .astrology:    return "sparkles.rectangle.stack"
        }
    }
}

// MARK: - Reading Article Model
struct ReadingArticle: Identifiable, Codable {
    let id: UUID
    let title: String
    let subtitle: String
    let category: ReadingCategory
    let readingMinutes: Int
    let summary: String
    let content: String
    let imageName: String   // SF Symbol or asset name used as background keyword
    let date: Date
    let isFeatured: Bool
}
