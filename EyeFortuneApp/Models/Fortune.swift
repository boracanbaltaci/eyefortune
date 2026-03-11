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
    }
}
