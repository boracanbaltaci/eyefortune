import Foundation
import SwiftUI
import Combine

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
        articles.first(where: { $0.isFeatured })
    }

    var nonFeaturedFiltered: [ReadingArticle] {
        filteredArticles.filter { !$0.isFeatured }
    }

    init() {
        loadTodaysArticles()
    }

    // Generates deterministic daily articles seeded by today's date
    func loadTodaysArticles() {
        let cal = Calendar.current
        let now = Date()
        let dayOfYear = cal.ordinality(of: .day, in: .year, for: now) ?? 1
        let pool = Self.allArticlePool
        let count = pool.count
        // Rotate the pool by dayOfYear, then take the first 6
        let rotated = (0..<count).map { pool[($0 + dayOfYear) % count] }
        articles = Array(rotated.prefix(6)).enumerated().map { idx, article in
            ReadingArticle(
                id: article.id,
                title: article.title,
                subtitle: article.subtitle,
                category: article.category,
                readingMinutes: article.readingMinutes,
                summary: article.summary,
                content: article.content,
                imageName: article.imageName,
                date: now,
                isFeatured: idx == 0
            )
        }
    }

    // MARK: - Article Pool
    static let allArticlePool: [ReadingArticle] = [
        ReadingArticle(
            id: UUID(),
            title: "Yıldızların Dili: Temel Astroloji",
            subtitle: "Astroloji 101",
            category: .astrology,
            readingMinutes: 5,
            summary: "Doğum haritanız, doğduğunuz andaki gökyüzünün bir fotoğrafıdır ve potansiyellerinizi fısıldar.",
            content: "Astroloji, gezegenlerin ve yıldızların insan yaşamı üzerindeki etkilerini inceleyen kadim bir gözlem sanatıdır. Güneş burcunuz egonuzu, Ay burcunuz duygularınızı, Yükselen burcunuz ise dış dünyaya sunduğunuz maskeyi temsil eder. Bu üçlü, karakterinizin temelini oluşturur.",
            imageName: "astrology_stars",
            date: Date(),
            isFeatured: false
        ),
        ReadingArticle(
            id: UUID(),
            title: "Ruhsal Uyanışın Belirtileri",
            subtitle: "Spiritüalizm",
            category: .spiritualism,
            readingMinutes: 4,
            summary: "Dünyayı ve kendinizi algılama biçiminiz değişiyorsa, ruhsal bir dönüşüm yaşıyor olabilirsiniz.",
            content: "Ruhsal uyanış, egonun ötesine geçme ve evrensel bir bütünlük hissetme sürecidir. Eşzamanlılıklar (sayı sekansları, rastlantılar), doğaya karşı artan hassasiyet ve yüzeysel konulardan uzaklaşma en yaygın belirtilerdir. Bu süreç sancılı olabilir ama özgürleştiricidir.",
            imageName: "spiritual_awakening",
            date: Date(),
            isFeatured: false
        ),
        ReadingArticle(id: UUID(), title: "Derin Meditasyon Teknikleri", subtitle: "İleri Seviye", category: .meditation, readingMinutes: 7, summary: "Zihnin en derin katmanlarına yolculuk.", content: "Vipassana ve Zen meditasyonu gibi teknikler, gerçekliğin doğasını anlamamıza yardımcı olur.", imageName: "meditation_deep", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Göz Rengi ve Karakter", subtitle: "Kişilik Analizi", category: .personality, readingMinutes: 3, summary: "Gözleriniz ruhunuzun aynasıdır.", content: "İris yapısı ve renk tonları, genetik mirasınızın yanı sıra enerjisel eğilimlerinizi de yansıtır.", imageName: "eye_personality", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Zaman Yönetimi Ritualü", subtitle: "Gelişim", category: .development, readingMinutes: 4, summary: "Zamanı verimli kullanmanın mistik yolu.", content: "Zamanı bir düşman değil, bir akış olarak görün.", imageName: "time_management", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Dijital Detoks", subtitle: "Mindfulness", category: .mindfulness, readingMinutes: 5, summary: "Ekranlardan uzaklaşın, kendinize dönün.", content: "Mavi ışık yerine yıldız ışığına odaklanın.", imageName: "digital_detox", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Beslenme ve Frekans", subtitle: "Sağlık", category: .wellness, readingMinutes: 6, summary: "Yediğiniz her şey bir enerjidir.", content: "Yüksek titreşimli gıdalar ruhsal sağlığı destekler.", imageName: "food_frequency", date: Date(), isFeatured: false),
        
        ReadingArticle(id: UUID(), title: "Retro Dönemlerinde Hayatta Kalma", subtitle: "Astroloji", category: .astrology, readingMinutes: 5, summary: "Merkür retrosu sizi durdurmasın.", content: "Retrolar içe dönmek ve yarım kalan işleri tamamlamak için harika fırsatlardır.", imageName: "retrograde", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Çakra Dengeleme", subtitle: "Spiritüalizm", category: .spiritualism, readingMinutes: 6, summary: "Enerji merkezlerinizi hizalayın.", content: "Yedi ana çakradaki blokajları kaldırmak yaşam enerjisini artırır.", imageName: "chakras", date: Date(), isFeatured: false),
        
        ReadingArticle(id: UUID(), title: "Yürüyüş Meditasyonu", subtitle: "Meditasyon", category: .meditation, readingMinutes: 4, summary: "Her adımda huzur.", content: "Yürürken yerle olan temasınızı hissedin.", imageName: "walking_med", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Gölge Benlik", subtitle: "Kişilik", category: .personality, readingMinutes: 6, summary: "Karanlık yanınızla barışın.", content: "Carl Jung'un gölge kavramı, bastırılmış duyguları keşfetmeyi sağlar.", imageName: "shadow_self", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Finansal Bolluk Bilinci", subtitle: "Gelişim", category: .development, readingMinutes: 5, summary: "Kıtlık bilincinden bolluk bilincine.", content: "Evrenin kaynakları sınırsızdır.", imageName: "abundance", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Mindful Dinleme", subtitle: "Mindfulness", category: .mindfulness, readingMinutes: 3, summary: "Gerçekten duymayı öğrenin.", content: "Sadece kelimeleri değil, duyguları da dinleyin.", imageName: "listening", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Doğal Kristaller", subtitle: "Sağlık", category: .wellness, readingMinutes: 4, summary: "Taşların şifalı gücü.", content: "Ametist ve kuvars gibi taşlar enerji alanınızı temizler.", imageName: "crystals", date: Date(), isFeatured: false),
        
        ReadingArticle(id: UUID(), title: "Ay Fazları ve Ritüeller", subtitle: "Astroloji", category: .astrology, readingMinutes: 5, summary: "Yeniay ve Dolunay enerjisi.", content: "Her faz, hayatınızda farklı bir niyet belirlemek için uygundur.", imageName: "moon_phases", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Üçüncü Göz Aktivasyonu", subtitle: "Spiritüalizm", category: .spiritualism, readingMinutes: 7, summary: "Sezgilerinizi uyandırın.", content: "Epifiz bezi ve sezgisel görü.", imageName: "third_eye", date: Date(), isFeatured: false),
        
        ReadingArticle(id: UUID(), title: "Yin ve Yang Dengesi", subtitle: "Meditasyon", category: .meditation, readingMinutes: 5, summary: "Zıt kutupların uyumu.", content: "Eril ve dişil enerjiyi dengeleyin.", imageName: "yin_yang", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Bağlanma Stilleri", subtitle: "Kişilik", category: .personality, readingMinutes: 5, summary: "Neden böyle seviyoruz?", content: "Güvenli, kaygılı ve kaçıngan bağlanma.", imageName: "attachment", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Öz Şefkat Pratiği", subtitle: "Gelişim", category: .development, readingMinutes: 4, summary: "Kendinize nazik olun.", content: "Hatalarınızı bir öğrenme süreci olarak görün.", imageName: "self_love", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Mindful Yemek", subtitle: "Mindfulness", category: .mindfulness, readingMinutes: 4, summary: "Lokmaların tadına varın.", content: "Yemek yerken dikkatiniz sadece tabakta olsun.", imageName: "mindful_eating", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Biyoenerji Temelleri", subtitle: "Sağlık", category: .wellness, readingMinutes: 6, summary: "Vücudun enerji alanı.", content: "Ellerle şifa ve enerji aktarımı.", imageName: "bioenergy", date: Date(), isFeatured: false),
        
        ReadingArticle(id: UUID(), title: "Yükselen Burcun Gizemi", subtitle: "Astroloji", category: .astrology, readingMinutes: 4, summary: "Dış dünyaya karşı duruşunuz.", content: "Birinci ev ve fiziksel görünüm.", imageName: "rising_sign", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Astral Seyahat Nedir?", subtitle: "Spiritüalizm", category: .spiritualism, readingMinutes: 8, summary: "Beden dışı deneyimler.", content: "Ruhun fiziksel bedenden geçici ayrılışı.", imageName: "astral_travel", date: Date(), isFeatured: false),
        ReadingArticle(
            id: UUID(),
            title: "Büyüme Zihniyeti: Yetenek mi, Çaba mı?",
            subtitle: "Kişisel gelişim",
            category: .development,
            readingMinutes: 5,
            summary: "Carol Dweck'in araştırmaları, zekanın sabit olmadığını kanıtladı. Başarı, yeteneğe değil zihniyet seçimine bağlıdır.",
            content: "Stanford Psikoloji Profesörü Carol Dweck, onlarca yıllık araştırmasını iki kavrama indirdi: Sabit Zihniyet ve Büyüme Zihniyeti. Büyüme zihniyetiyle hatalar yapan kişilerin beyinleri, o hatayı işlemek için daha fazla elektriksel aktivite gösterir. Yani gerçek anlamda daha fazla öğrenirler.",
            imageName: "growth_mindset",
            date: Date(),
            isFeatured: false
        )
    ]
}

