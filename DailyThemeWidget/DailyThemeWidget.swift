import WidgetKit
import SwiftUI

// MARK: - Dedicated Models for Widget (Self-Contained)
struct WidgetDailyTheme: Identifiable, Codable {
    var id: String
    let nameKey: String
    let symbol: String
    let colorHex: String
    
    var color: Color {
        Color(widgetHex: colorHex)
    }
}

class WidgetThemeManager {
    static let shared = WidgetThemeManager()
    
    private let themes: [WidgetDailyTheme] = [
        WidgetDailyTheme(id: "theme_love", nameKey: "theme_love", symbol: "heart.fill", colorHex: "#FF4B91"),
        WidgetDailyTheme(id: "theme_friendship", nameKey: "theme_friendship", symbol: "person.2.fill", colorHex: "#2ECC71"),
        WidgetDailyTheme(id: "theme_family", nameKey: "theme_family", symbol: "house.fill", colorHex: "#FFB000"),
        WidgetDailyTheme(id: "theme_peace", nameKey: "theme_peace", symbol: "leaf.fill", colorHex: "#65B741"),
        WidgetDailyTheme(id: "theme_anxiety", nameKey: "theme_anxiety", symbol: "cloud.bolt.rain.fill", colorHex: "#7077A1"),
        WidgetDailyTheme(id: "theme_excitement", nameKey: "theme_excitement", symbol: "sparkles", colorHex: "#FF004D"),
        WidgetDailyTheme(id: "theme_sports", nameKey: "theme_sports", symbol: "figure.run", colorHex: "#FBA834"),
        WidgetDailyTheme(id: "theme_entertainment", nameKey: "theme_entertainment", symbol: "party.popper.fill", colorHex: "#9D44C0"),
        WidgetDailyTheme(id: "theme_work", nameKey: "theme_work", symbol: "briefcase.fill", colorHex: "#40A2E3"),
        WidgetDailyTheme(id: "theme_education", nameKey: "theme_education", symbol: "book.closed.fill", colorHex: "#535C91")
    ]
    
    func currentTheme() -> WidgetDailyTheme {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayOfYear % themes.count
        return themes[index]
    }
    
    func theme(at index: Int) -> WidgetDailyTheme {
        return themes[max(0, min(index, themes.count - 1))]
    }
}

// MARK: - Light Localization Helper
struct WidgetLocalizer {
    static func t(_ key: String) -> String {
        let sharedDefaults = UserDefaults(suiteName: "group.com.boradev.eyefortune") ?? .standard
        let language = sharedDefaults.string(forKey: "appLanguage") ?? "tr"
        
        let translations: [String: [String: String]] = [
            "tr": [
                "widget_header": "Günün Teması:",
                "theme_love": "AŞK",
                "theme_friendship": "ARKADAŞLIK",
                "theme_family": "AİLE",
                "theme_peace": "HUZUR",
                "theme_anxiety": "ENDİŞE",
                "theme_excitement": "HEYECAN",
                "theme_sports": "SPOR",
                "theme_entertainment": "EĞLENCE",
                "theme_work": "İŞ",
                "theme_education": "EĞİTİM"
            ],
            "en": [
                "widget_header": "Daily Theme:",
                "theme_love": "LOVE",
                "theme_friendship": "FRIENDSHIP",
                "theme_family": "FAMILY",
                "theme_peace": "PEACE",
                "theme_anxiety": "ANXIETY",
                "theme_excitement": "EXCITEMENT",
                "theme_sports": "SPORTS",
                "theme_entertainment": "ENTERTAINMENT",
                "theme_work": "WORK",
                "theme_education": "EDUCATION"
            ],
            "fr": [
                "widget_header": "Thème du jour:",
                "theme_love": "AMOUR",
                "theme_friendship": "AMITIÉ",
                "theme_family": "FAMILLE",
                "theme_peace": "PAIX",
                "theme_anxiety": "ANXIÉTÉ",
                "theme_excitement": "EXCITATION",
                "theme_sports": "SPORTS",
                "theme_entertainment": "DIVERTISSEMENT",
                "theme_work": "TRAVAIL",
                "theme_education": "ÉDUCATION"
            ],
            "es": [
                "widget_header": "Tema del día:",
                "theme_love": "AMOR",
                "theme_friendship": "AMISTAD",
                "theme_family": "FAMILIA",
                "theme_peace": "PAZ",
                "theme_anxiety": "ANSIEDAD",
                "theme_excitement": "EMOCIÓN",
                "theme_sports": "DEPORTES",
                "theme_entertainment": "ENTRETENIMIENTO",
                "theme_work": "TRABAJO",
                "theme_education": "EDUCACIÓN"
            ],
            "de": [
                "widget_header": "Tages-Thema:",
                "theme_love": "LIEBE",
                "theme_friendship": "FREUNDSCHAFT",
                "theme_family": "FAMILIE",
                "theme_peace": "FRIEDEN",
                "theme_anxiety": "ANGST",
                "theme_excitement": "AUFREGUNG",
                "theme_sports": "SPORT",
                "theme_entertainment": "UNTERHALTUNG",
                "theme_work": "ARBEIT",
                "theme_education": "BILDUNG"
            ],
            "it": [
                "widget_header": "Tema del Giorno:",
                "theme_love": "AMORE",
                "theme_friendship": "AMICIZIA",
                "theme_family": "FAMIGLIA",
                "theme_peace": "PACE",
                "theme_anxiety": "ANSIA",
                "theme_excitement": "EMOZIONE",
                "theme_sports": "SPORT",
                "theme_entertainment": "DIVERTIMENTO",
                "theme_work": "LAVORO",
                "theme_education": "ISTRUZIONE"
            ]
        ]
        
        return translations[language]?[key] ?? translations["en"]?[key] ?? key
    }
}

// MARK: - Widget Logic
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), theme: WidgetThemeManager.shared.theme(at: 0))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), theme: getTheme())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, theme: getTheme())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func getTheme() -> WidgetDailyTheme {
        let sharedDefaults = UserDefaults(suiteName: "group.com.boradev.eyefortune") ?? .standard
        let overrideIndex = sharedDefaults.integer(forKey: "widgetOverrideIndex")
        
        if sharedDefaults.object(forKey: "widgetOverrideIndex") != nil && overrideIndex >= 0 {
            return WidgetThemeManager.shared.theme(at: overrideIndex)
        }
        return WidgetThemeManager.shared.currentTheme()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let theme: WidgetDailyTheme
}

struct DailyThemeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            // Full Background
            entry.theme.color
                .ignoresSafeArea()
            
            // Subtle Gradient for Depth
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.15), .clear, .white.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                Text(WidgetLocalizer.t("widget_header"))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
                    .tracking(0.5)
                    .padding(.top, 14)
                
                Spacer()
                
                // Central Element (Larger)
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 86, height: 86)
                        .blur(radius: 0.5)
                    
                    if entry.theme.symbol.count == 1 {
                        Text(entry.theme.symbol)
                            .font(.system(size: 46))
                    } else {
                        Image(systemName: entry.theme.symbol)
                            .font(.system(size: 42, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                
                Spacer()
                
                // Theme Name
                Text(WidgetLocalizer.t(entry.theme.nameKey))
                    .font(.system(size: 16, weight: .black, design: .serif))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .padding(.bottom, 14)
            }
        }
        .containerBackground(entry.theme.color.gradient, for: .widget) // Important for newer iOS
    }
}

struct DailyThemeWidget: Widget {
    let kind: String = "DailyThemeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyThemeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Günün Teması")
        .description("Her gün değişen mistik temayı takip edin.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled() // REMOVE WHITE EDGES / PADDING
    }
}

// MARK: - Color Hex Extension (Widget Local)
extension Color {
    init(widgetHex hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
