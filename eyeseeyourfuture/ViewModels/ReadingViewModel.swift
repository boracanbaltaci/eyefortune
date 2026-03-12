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
        // --- ASTROLOGY ---
        ReadingArticle(id: UUID(), title: "Yıldızların Dili: Temel Astroloji", subtitle: "Astroloji 101", category: .astrology, readingMinutes: 5, summary: "Doğum haritanız, doğduğunuz andaki gökyüzünün bir fotoğrafıdır.", content: "Astroloji, gezegenlerin ve yıldızların insan yaşamı üzerindeki etkilerini inceleyen kadim bir gözlem sanatıdır. Güneş burcunuz egonuzu, Ay burcunuz duygularınızı, Yükselen burcunuz ise dış dünyaya sunduğunuz maskeyi temsil eder.", imageName: "astrology_stars", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Retro Dönemlerinde Hayatta Kalma", subtitle: "Astroloji", category: .astrology, readingMinutes: 5, summary: "Merkür retrosu sizi durdurmasın.", content: "Retrolar içe dönmek ve yarım kalan işleri tamamlamak için harika fırsatlardır. Bu dönemde yeni başlangıçlar yerine geçmişi temzilemeye odaklanın.", imageName: "retrograde", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Ay Fazları ve Ritüeller", subtitle: "Astroloji", category: .astrology, readingMinutes: 5, summary: "Yeniay ve Dolunay enerjisi.", content: "Her faz, hayatınızda farklı bir niyet belirlemek için uygundur. Yeniay tohum ekme, Dolunay ise hasat ve bırakma zamanıdır.", imageName: "moon_phases", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Yükselen Burcun Gizemi", subtitle: "Astroloji", category: .astrology, readingMinutes: 4, summary: "Dış dünyaya karşı duruşunuz.", content: "Yükselen burç, dünyaya baktığınız penceredir. Fiziksel özelliklerinizden ilk izleniminize kadar birçok konuyu yönetir.", imageName: "rising_sign", date: Date(), isFeatured: false),

        // --- SPIRITUALISM ---
        ReadingArticle(id: UUID(), title: "Ruhsal Uyanışın Belirtileri", subtitle: "Spiritüalizm", category: .spiritualism, readingMinutes: 4, summary: "Ruhsal bir dönüşüm yaşıyor olabilirsiniz.", content: "Ruhsal uyanış, egonun ötesine geçme ve evrensel bir bütünlük hissetme sürecidir. Eşzamanlılıklar ve artan hassasiyet en yaygın belirtilerdir.", imageName: "spiritual_awakening", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Çakra Dengeleme", subtitle: "Spiritüalizm", category: .spiritualism, readingMinutes: 6, summary: "Enerji merkezlerinizi hizalayın.", content: "Yedi ana çakradaki blokajları kaldırmak yaşam enerjisini artırır. Kök çakradan tepe çakraya kadar her merkez farklı bir boyutu temsil eder.", imageName: "chakras", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Üçüncü Göz Aktivasyonu", subtitle: "Spiritüalizm", category: .spiritualism, readingMinutes: 7, summary: "Sezgilerinizi uyandırın.", content: "Epifiz bezi ve sezgisel görü. Sezgilerinizi güçlendirmek için sessizliğe ve iç sesinize daha fazla yer açın.", imageName: "third_eye", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Astral Seyahat Nedir?", subtitle: "Spiritüalizm", category: .spiritualism, readingMinutes: 8, summary: "Beden dışı deneyimler.", content: "Ruhun fiziksel bedenden geçici ayrılışı üzerine kadim bilgiler ve modern araştırmalar.", imageName: "astral_travel", date: Date(), isFeatured: false),

        // --- MEDITATION ---
        ReadingArticle(id: UUID(), title: "Derin Meditasyon Teknikleri", subtitle: "İleri Seviye", category: .meditation, readingMinutes: 7, summary: "Zihnin en derin katmanlarına yolculuk.", content: "Vipassana ve Zen meditasyonu gibi teknikler, gerçekliğin doğasını anlamamıza yardımcı olur. Sadece nefese odaklanmak bile zihni dinginleştirir.", imageName: "meditation_deep", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Yürüyüş Meditasyonu", subtitle: "Meditasyon", category: .meditation, readingMinutes: 4, summary: "Her adımda huzur.", content: "Yürürken yerle olan temasınızı hissedin. Adımlarınızın ritmi ile nefesinizi uyumlu hale getirin.", imageName: "walking_med", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Yin ve Yang Dengesi", subtitle: "Meditasyon", category: .meditation, readingMinutes: 5, summary: "Zıt kutupların uyumu.", content: "Eril ve dişil enerjiyi dengelemek için sessizliğin gücünü kullanın. İçsel zıtlıklarınızla barışın.", imageName: "yin_yang", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Sabah Meditasyonu", subtitle: "Güne Merhaba", category: .meditation, readingMinutes: 3, summary: "Güne yüksek enerjiyle başlayın.", content: "Sabahın ilk ışıklarıyla yapılan niyet meditasyonu, günün geri kalanını şekillendirir.", imageName: "morning_med", date: Date(), isFeatured: false),

        // --- PERSONALITY ---
        ReadingArticle(id: UUID(), title: "Göz Rengi ve Karakter", subtitle: "Kişilik Analizi", category: .personality, readingMinutes: 3, summary: "Gözleriniz ruhunuzun aynasıdır.", content: "İris yapısı ve renk tonları, genetik mirasınızın yanı sıra enerjisel eğilimlerinizi de yansıtır.", imageName: "eye_personality", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Gölge Benlik", subtitle: "Kişilik", category: .personality, readingMinutes: 6, summary: "Karanlık yanınızla barışın.", content: "Carl Jung'un gölge kavramı, bastırılmış duyguları keşfetmeyi sağlar. Karanlığı kabul etmek bütünleşmenin ilk adımıdır.", imageName: "shadow_self", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Bağlanma Stilleri", subtitle: "Kişilik", category: .personality, readingMinutes: 5, summary: "Neden böyle seviyoruz?", content: "Güvenli, kaygılı ve kaçıngan bağlanma stilleri ilişkilerimizi nasıl şekillendirir?", imageName: "attachment", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Rüya Sembolizmi", subtitle: "Bilinçaltı", category: .personality, readingMinutes: 7, summary: "Rüyalarınız ne anlatıyor?", content: "Bilinçaltınızın sembolik dili rüyalardadır. Tekrarlayan rüyalar önemli mesajlar taşıyor olabilir.", imageName: "dreams", date: Date(), isFeatured: false),

        // --- DEVELOPMENT ---
        ReadingArticle(id: UUID(), title: "Zaman Yönetimi Ritualü", subtitle: "Gelişim", category: .development, readingMinutes: 4, summary: "Zamanı verimli kullanmanın mistik yolu.", content: "Zamanı bir düşman değil, bir akış olarak görün. Önceliklerinizi ruhsal amacınıza göre belirleyin.", imageName: "time_management", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Finansal Bolluk Bilinci", subtitle: "Gelişim", category: .development, readingMinutes: 5, summary: "Bolluk bilincine geçiş.", content: "Evrenin kaynakları sınırsızdır. Kıtlık korkusundan sıyrılıp verme ve alma dengesini kurun.", imageName: "abundance", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Öz Şefkat Pratiği", subtitle: "Gelişim", category: .development, readingMinutes: 4, summary: "Kendinize nazik olun.", content: "Hatalarınızı bir öğrenme süreci olarak görün. Kendinize bir sevdiğinize davrandığınız gibi şefkatle yaklaşın.", imageName: "self_love", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Büyüme Zihniyeti", subtitle: "Zihinsel Dönüşüm", category: .development, readingMinutes: 5, summary: "Yetenek mi, çaba mı?", content: "Becerilerimizi geliştirme kapasitemiz sınırsızdır. Her engeli bir büyüme fırsatı olarak görün.", imageName: "growth_mindset", date: Date(), isFeatured: false),

        // --- MINDFULNESS ---
        ReadingArticle(id: UUID(), title: "Dijital Detoks", subtitle: "Mindfulness", category: .mindfulness, readingMinutes: 5, summary: "Ekranlardan uzaklaşın, kendinize dönün.", content: "Mavi ışık yerine yıldız ışığına odaklanın. Günlük olarak teknolojiye sessiz bir mola verin.", imageName: "digital_detox", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Mindful Dinleme", subtitle: "Mindfulness", category: .mindfulness, readingMinutes: 3, summary: "Gerçekten duymayı öğrenin.", content: "Sadece kelimeleri değil, duyguları da dinleyin. Karşınızdakine tam varlığınızla şahitlik edin.", imageName: "listening", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Mindful Yemek", subtitle: "Mindfulness", category: .mindfulness, readingMinutes: 4, summary: "Lokmaların tadına varın.", content: "Yemek yerken dikkatiniz sadece tabakta olsun. Tatları, kokuları ve dokuları tam farkındalıkla deneyimleyin.", imageName: "mindful_eating", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Nefes Farkındalığı", subtitle: "Şimdi ve Burada", category: .mindfulness, readingMinutes: 3, summary: "Yaşamın en basit anahtarı.", content: "Nefesiniz sizin çapanızdır. Zihniniz dağıldığında nazikçe nefesinize geri dönün.", imageName: "breath", date: Date(), isFeatured: false),

        // --- WELLNESS ---
        ReadingArticle(id: UUID(), title: "Beslenme ve Frekans", subtitle: "Sağlık", category: .wellness, readingMinutes: 6, summary: "Yediğiniz her şey bir enerjidir.", content: "Yüksek titreşimli gıdalar ruhsal sağlığı destekler. Toprak ana ile bağınızı güçlendiren besinleri seçin.", imageName: "food_frequency", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Doğal Kristaller", subtitle: "Sağlık", category: .wellness, readingMinutes: 4, summary: "Taşların şifalı gücü.", content: "Ametist ve kuvars gibi taşlar enerji alanınızı temizler. Her kristalin kendine has bir titreşim frekansı vardır.", imageName: "crystals", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Biyoenerji Temelleri", subtitle: "Sağlık", category: .wellness, readingMinutes: 6, summary: "Vücudun enerji alanı.", content: "Ellerle şifa ve enerji aktarımı. Vücudunuzdaki yaşam enerjisini hissetmeyi ve yönlendirmeyi öğrenin.", imageName: "bioenergy", date: Date(), isFeatured: false),
        ReadingArticle(id: UUID(), title: "Uyku Ritüeli", subtitle: "Dinlenme", category: .wellness, readingMinutes: 5, summary: "Ruhsal dinlenme için.", content: "Yatmadan önce yapılan sakinleştirici pratikler rüyalarınızın kalitesini artırır ve enerjinizi yeniler.", imageName: "sleep", date: Date(), isFeatured: false),
    ]
}

