import Foundation

/// Defines a user's state to limit scans and track history
struct User: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String?
    var birthDate: Date?
    var element: String?
    
    var lastScanDate: Date?
    var savedFortunes: [Fortune] = []
    
    var canScanToday: Bool {
        guard let lastScan = lastScanDate else { return true }
        return !Calendar.current.isDateInToday(lastScan)
    }
}
