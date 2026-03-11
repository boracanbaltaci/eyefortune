import Foundation

// MARK: - Reading Category
enum ReadingCategory: String, CaseIterable, Identifiable {
    case all           = "Tümü"
    case meditation    = "Meditasyon"
    case personality   = "Kişilik"
    case development   = "Gelişim"
    case mindfulness   = "Mindfulness"
    case wellness      = "Sağlık"

    var id: String { self.rawValue }

    var icon: String {
        switch self {
        case .all:          return "square.grid.2x2"
        case .meditation:   return "figure.mind.and.body"
        case .personality:  return "brain.head.profile"
        case .development:  return "chart.line.uptrend.xyaxis"
        case .mindfulness:  return "leaf"
        case .wellness:     return "heart.fill"
        }
    }
}

// MARK: - Reading Article Model
struct ReadingArticle: Identifiable {
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
