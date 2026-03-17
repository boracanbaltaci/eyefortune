import Combine
import Foundation
import SwiftUI

// MARK: - Reading ViewModel
class ReadingViewModel: ObservableObject {
    @Published var articles: [ReadingArticle] = []
    @Published var selectedCategory: ReadingCategory = .all

    var filteredArticles: [ReadingArticle] {
        if selectedCategory == .all {
            return articles
        }
        return articles.filter { $0.category == selectedCategory }
    }

    var featuredArticle: ReadingArticle? {
        filteredArticles.first(where: { $0.isFeatured })
    }

    var nonFeaturedFiltered: [ReadingArticle] {
        filteredArticles.filter { !$0.isFeatured }
    }

    private func saveKey(for language: AppLanguage) -> String {
        return "ai_reading_articles_\(language.rawValue)"
    }
    
    private func lastUpdateKey(for language: AppLanguage) -> String {
        return "last_weekly_reading_update_\(language.rawValue)"
    }
    
    private let openAIService = OpenAIService.shared

    init() {
        // Initial load will happen in onAppear when we have the language
    }
    
    func loadArticles(for language: AppLanguage) {
        if let data = UserDefaults.standard.data(forKey: saveKey(for: language)),
           let decoded = try? JSONDecoder().decode([ReadingArticle].self, from: data) {
            articles = decoded
        } else {
            // Load static pool as fallback or initial state
            loadStaticPool(for: language)
        }
    }

    private func saveArticles(for language: AppLanguage) {
        if let encoded = try? JSONEncoder().encode(articles) {
            UserDefaults.standard.set(encoded, forKey: saveKey(for: language))
        }
    }

    private func loadStaticPool(for language: AppLanguage) {
        let pool = Self.allArticlePool(for: language)
        articles = pool
    }
    
    func checkAndFetchWeeklyArticles(language: AppLanguage) {
        // First, load what we have for this language
        loadArticles(for: language)
        
        let now = Date()
        let lastUpdate = UserDefaults.standard.object(forKey: lastUpdateKey(for: language)) as? Date ?? Date.distantPast
        
        // Calculate the most recent Monday at 12:00 PM
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        components.weekday = 2 // Monday
        components.hour = 12
        components.minute = 0
        components.second = 0
        
        guard let thisMondayNoon = calendar.date(from: components) else { return }
        
        // If we haven't updated since this Monday noon, and it's currently past Monday noon
        // OR if we have NO articles at all for this language
        if (lastUpdate < thisMondayNoon && now >= thisMondayNoon) || articles.isEmpty {
            // If empty, load static pool first so UI isn't blank
            if articles.isEmpty {
                loadStaticPool(for: language)
            }
            fetchAllCategories(language: language)
            UserDefaults.standard.set(now, forKey: lastUpdateKey(for: language))
        }
    }
    
    private func fetchAllCategories(language: AppLanguage) {
        let categoriesToFetch = ReadingCategory.allCases.filter { $0 != .all }
        
        for category in categoriesToFetch {
            fetchArticles(for: category, language: language)
        }
    }
    
    private func fetchArticles(for category: ReadingCategory, language: AppLanguage) {
        let prompt = AIPromptGenerator.generateWeeklyArticlesPrompt(category: category, language: language)
        
        openAIService.generateFortune(prompt: prompt) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let jsonString):
                    self?.parseAndAppendArticles(jsonString, category: category, language: language)
                case .failure(let error):
                    print("Error fetching articles for \(category.rawValue): \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func parseAndAppendArticles(_ jsonString: String, category: ReadingCategory, language: AppLanguage) {
        // Clean potential markdown code blocks from JSON
        let cleanJSON = jsonString.replacingOccurrences(of: "```json", with: "").replacingOccurrences(of: "```", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let data = cleanJSON.data(using: .utf8) else { return }
        
        struct RawArticle: Codable {
            let title: String
            let subtitle: String
            let readingMinutes: Int
            let summary: String
            let content: String
            let imageName: String
        }
        
        do {
            let rawArticles = try JSONDecoder().decode([RawArticle].self, from: data)
            let newArticles = rawArticles.enumerated().map { idx, raw in
                ReadingArticle(
                    id: UUID(),
                    title: raw.title,
                    subtitle: raw.subtitle,
                    category: category,
                    readingMinutes: raw.readingMinutes,
                    summary: raw.summary,
                    content: raw.content,
                    imageName: raw.imageName,
                    date: Date(),
                    isFeatured: category == .meditation && idx == 0 // Example logic for featured
                )
            }
            
            // Remove old articles of this category and add new ones
            self.articles.removeAll(where: { $0.category == category })
            self.articles.append(contentsOf: newArticles)
            self.saveArticles(for: language)
            
        } catch {
            print("Failed to parse articles for \(category.rawValue): \(error)")
        }
    }

    // MARK: - Article Pool
    static func allArticlePool(for language: AppLanguage) -> [ReadingArticle] {
        if language == .turkish {
            return [
                // --- ASTROLOGY ---
                ReadingArticle(id: UUID(), title: "Yıldızların Dili: Temel Astroloji", subtitle: "Astroloji 101", category: .astrology, readingMinutes: 5, summary: "Doğum haritanız, doğduğunuz andaki gökyüzünün bir fotoğrafıdır.", content: "Astroloji, gezegenlerin ve yıldızların insan yaşamı üzerindeki etkilerini inceleyen kadim bir gözlem sanatıdır. Güneş burcunuz egonuzu, Ay burcunuz duygularınızı, Yükselen burcunuz ise dış dünyaya sunduğunuz maskeyi temsil eder.", imageName: "astrology_stars", date: Date(), isFeatured: false),
                ReadingArticle(id: UUID(), title: "Retro Dönemlerinde Hayatta Kalma", subtitle: "Astroloji", category: .astrology, readingMinutes: 5, summary: "Merkür retrosu sizi durdurmasın.", content: "Retrolar içe dönmek ve yarım kalan işleri tamamlamak için harika fırsatlardır. Bu dönemde yeni başlangıçlar yerine geçmişi temzilemeye odaklanın.", imageName: "retrograde", date: Date(), isFeatured: false),

                // --- SPIRITUALISM ---
                ReadingArticle(id: UUID(), title: "Ruhsal Uyanışın Belirtileri", subtitle: "Spiritüalizm", category: .spiritualism, readingMinutes: 4, summary: "Ruhsal bir dönüşüm yaşıyor olabilirsiniz.", content: "Ruhsal uyanış, egonun ötesine geçme ve evrensel bir bütünlük hissetme sürecidir. Eşzamanlılıklar ve artan hassasiyet en yaygın belirtilerdir.", imageName: "spiritual_awakening", date: Date(), isFeatured: false),
                ReadingArticle(id: UUID(), title: "Çakra Dengeleme", subtitle: "Spiritüalizm", category: .spiritualism, readingMinutes: 6, summary: "Enerji merkezlerinizi hizalayın.", content: "Yedi ana çakradaki blokajları kaldırmak yaşam enerjisini artırır. Kök çakradan tepe çakraya kadar her merkez farklı bir boyutu temsil eder.", imageName: "chakras", date: Date(), isFeatured: false),

                // --- MEDITATION ---
                ReadingArticle(id: UUID(), title: "Derin Meditasyon Teknikleri", subtitle: "İleri Seviye", category: .meditation, readingMinutes: 7, summary: "Zihnin en derin katmanlarına yolculuk.", content: "Vipassana ve Zen meditasyonu gibi teknikler, gerçekliğin doğasını anlamamıza yardımcı olur. Sadece nefese odaklanmak bile zihni dinginleştirir.", imageName: "meditation_deep", date: Date(), isFeatured: false),

                // --- PERSONALITY ---
                ReadingArticle(id: UUID(), title: "Göz Rengi ve Karakter", subtitle: "Kişilik Analizi", category: .personality, readingMinutes: 3, summary: "Gözleriniz ruhunuzun aynasıdır.", content: "İris yapısı ve renk tonları, genetik mirasınızın yanı sıra enerjisel eğilimlerinizi de yansıtır.", imageName: "eye_personality", date: Date(), isFeatured: false),

                // --- DEVELOPMENT ---
                ReadingArticle(id: UUID(), title: "Zaman Yönetimi Ritualü", subtitle: "Gelişim", category: .development, readingMinutes: 4, summary: "Zamanı verimli kullanmanın mistik yolu.", content: "Zamanı bir düşman değil, bir akış olarak görün. Önceliklerinizi ruhsal amacınıza göre belirleyin.", imageName: "time_management", date: Date(), isFeatured: false),

                // --- MINDFULNESS ---
                ReadingArticle(id: UUID(), title: "Dijital Detoks", subtitle: "Mindfulness", category: .mindfulness, readingMinutes: 5, summary: "Ekranlardan uzaklaşın, kendinize dönün.", content: "Mavi ışık yerine yıldız ışığına odaklanın. Günlük olarak teknolojiye sessiz bir mola verin.", imageName: "digital_detox", date: Date(), isFeatured: false),

                // --- WELLNESS ---
                ReadingArticle(id: UUID(), title: "Beslenme ve Frekans", subtitle: "Sağlık", category: .wellness, readingMinutes: 6, summary: "Yediğiniz her şey bir enerjidir.", content: "Yüksek titreşimli gıdalar ruhsal sağlığı destekler. Toprak ana ile bağınızı güçlendiren besinleri seçin.", imageName: "food_frequency", date: Date(), isFeatured: false),
            ]
        } else {
            // Default to English for all other languages
            return [
                // --- ASTROLOGY ---
                ReadingArticle(id: UUID(), title: "Language of the Stars: Basic Astrology", subtitle: "Astrology 101", category: .astrology, readingMinutes: 5, summary: "Your birth chart is a snapshot of the sky at the moment you were born.", content: "Astrology is an ancient art of observation that examines the effects of planets and stars on human life. Your Sun sign represents your ego, your Moon sign your emotions, and your Ascendant the mask you present to the outside world.", imageName: "astrology_stars", date: Date(), isFeatured: false),
                ReadingArticle(id: UUID(), title: "Survival During Retrograde Periods", subtitle: "Astrology", category: .astrology, readingMinutes: 5, summary: "Don't let Mercury retrograde stop you.", content: "Retrogrades are great opportunities to turn inward and complete unfinished business. During this period, focus on clearing the past instead of new beginnings.", imageName: "retrograde", date: Date(), isFeatured: false),

                // --- SPIRITUALISM ---
                ReadingArticle(id: UUID(), title: "Signs of Spiritual Awakening", subtitle: "Spiritualism", category: .spiritualism, readingMinutes: 4, summary: "You might be experiencing a spiritual transformation.", content: "Spiritual awakening is the process of moving beyond the ego and feeling a sense of universal unity. Synchronicities and increased sensitivity are the most common signs.", imageName: "spiritual_awakening", date: Date(), isFeatured: false),
                ReadingArticle(id: UUID(), title: "Chakra Balancing", subtitle: "Spiritualism", category: .spiritualism, readingMinutes: 6, summary: "Align your energy centers.", content: "Removing blockages in the seven main chakras increases life energy. Each center from the root chakra to the crown chakra represents a different dimension.", imageName: "chakras", date: Date(), isFeatured: false),

                // --- MEDITATION ---
                ReadingArticle(id: UUID(), title: "Deep Meditation Techniques", subtitle: "Advanced", category: .meditation, readingMinutes: 7, summary: "Journey to the deepest layers of the mind.", content: "Techniques like Vipassana and Zen meditation help us understand the nature of reality. Just focusing on the breath calings the mind.", imageName: "meditation_deep", date: Date(), isFeatured: false),

                // --- PERSONALITY ---
                ReadingArticle(id: UUID(), title: "Eye Color and Character", subtitle: "Personality Analysis", category: .personality, readingMinutes: 3, summary: "Your eyes are the mirror of your soul.", content: "Iris structure and color tones reflect your energetical tendencies as well as your genetic heritage.", imageName: "eye_personality", date: Date(), isFeatured: false),

                // --- DEVELOPMENT ---
                ReadingArticle(id: UUID(), title: "Time Management Ritual", subtitle: "Development", category: .development, readingMinutes: 4, summary: "The mystic way of using time efficiently.", content: "See time not as an enemy but as a flow. Determine your priorities according to your spiritual purpose.", imageName: "time_management", date: Date(), isFeatured: false),

                // --- MINDFULNESS ---
                ReadingArticle(id: UUID(), title: "Digital Detox", subtitle: "Mindfulness", category: .mindfulness, readingMinutes: 5, summary: "Step away from screens, return to yourself.", content: "Focus on starlight instead of blue light. Take a quiet break from technology daily.", imageName: "digital_detox", date: Date(), isFeatured: false),

                // --- WELLNESS ---
                ReadingArticle(id: UUID(), title: "Nutrition and Frequency", subtitle: "Wellness", category: .wellness, readingMinutes: 6, summary: "Everything you eat is an energy.", content: "High-vibration foods support spiritual health. Choose foods that strengthen your connection with Mother Earth.", imageName: "food_frequency", date: Date(), isFeatured: false),
            ]
        }
    }
}

