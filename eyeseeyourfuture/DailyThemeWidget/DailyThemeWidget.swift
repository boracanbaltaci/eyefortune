import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), theme: DailyThemeManager.shared.theme(at: 0))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), theme: getTheme())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, theme: getTheme())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getTheme() -> DailyTheme {
        let overrideIndex = UserDefaults.standard.integer(forKey: "widgetOverrideIndex")
        if overrideIndex >= 0 {
            return DailyThemeManager.shared.theme(at: overrideIndex)
        }
        return DailyThemeManager.shared.currentTheme()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let theme: DailyTheme
}

struct DailyThemeWidgetEntryView : View {
    var entry: Provider.Entry
    let lm = LocalizationManager()

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [entry.theme.color.opacity(0.8), entry.theme.color.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Glass effect overlay
            Color.white.opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                Text(lm.t(.widgetHeader))
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
                    .tracking(1)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .blur(radius: 1)
                    
                    Image(systemName: entry.theme.symbol)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
                
                Text(lm.t(entry.theme.nameKey))
                    .font(.system(size: 14, weight: .black, design: .serif))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            .padding(12)
        }
    }
}

// @main - Not: Widget'ı ayrı bir Target olarak eklediğinizde bu satırı etkinleştirin.
// Şu an ana modülde olduğu için çakışma yaşanmaması adına yorum satırına alındı.
struct DailyThemeWidget: Widget {
    let kind: String = "DailyThemeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyThemeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Günün Teması")
        .description("Her gün değişen mistik temayı takip edin.")
        .supportedFamilies([.systemSmall])
    }
}
