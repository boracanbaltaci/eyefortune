import Foundation

/// Represents a generated or daily fortune.
struct Fortune: Identifiable, Codable {
    var id: UUID = UUID()
    var text: String
    var dateGenerated: Date
    var type: FortuneType
    
    enum FortuneType: String, Codable {
        case daily = "Daily"
        case aiScan = "AI Scan"
        case personality = "Personality"
        case love = "Love"
        case health = "Health"
        case wealth = "Wealth"
        case career = "Career"
        case strengths = "Strengths"
        case weaknesses = "Weaknesses"
    }
    
    var language: AppLanguage? = .turkish
}
