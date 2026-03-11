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
            title: "Meditasyonun Beyin Üzerindeki Mucizevi Etkileri",
            subtitle: "Bilim ne diyor?",
            category: .meditation,
            readingMinutes: 5,
            summary: "Düzenli meditasyon pratiği yalnızca zihni sakinleştirmekle kalmaz; beynin yapısını ve işleyişini kalıcı olarak dönüştürür.",
            content: """
Nörobilim araştırmaları, düzenli meditasyon yapan kişilerin beyin kortekslerinin daha kalın olduğunu ortaya koyuyor. Bu bölgeler dikkat, içgözlem ve duyusal işlemeden sorumludur.

**Prefrontal Korteks Güçleniyor**
Meditasyon, kararlar verdiğimiz, duygularımızı düzenlediğimiz ve uzun vadeli planlar yaptığımız prefrontal korteksi güçlendirir. Düzenli pratisyenler daha sakin ve dengeli kararlar alır.

**Amigdala Küçülüyor**
Stres ve korku merkezimiz olan amigdala, sekiz haftalık meditasyonun ardından belirgin şekilde küçülür. Bu da günlük yaşamda kaygının azalması anlamına gelir.

**Varsayılan Mod Ağı Değişiyor**
Zihniniz boşta olduğunda aktif olan varsayılan mod ağı (DMN), meditasyon yapanlarda farklı çalışır; daha az olumsuz düşünce döngüsü, daha fazla şimdiki anın farkındalığı.

**Nasıl Başlayabilirsiniz?**
Günde yalnızca 10 dakika yeterlidir. Sessiz bir köşe bulun, oturun, gözlerinizi kapatın ve nefesinize odaklanın. Zihin dağıldığında yargılamadan dönün. Bu basit eylem, zamanla beyninizi dönüştürür.

Araştırmalar, yalnızca 8 haftada ölçülebilir beyin değişikliklerinin gerçekleştiğini gösteriyor. Başlamak için doğru an her zaman şimdiki andır.
""",
            imageName: "meditation_brain",
            date: Date(),
            isFeatured: true
        ),
        ReadingArticle(
            id: UUID(),
            title: "İçe Dönük mü, Dışa Dönük mü? İkisinin Ötesinde Bir Kimlik",
            subtitle: "Kişilik analizi",
            category: .personality,
            readingMinutes: 4,
            summary: "İçe ya da dışa dönüklük bir ikilemin iki ucu değil; bir spektrumun zengin ortasıdır. Ambivertlerin dünyasına hoş geldiniz.",
            content: """
Psikoloji dünyası uzun süre insanları iki kutba ayırdı: içe dönükler ve dışa dönükler. Ancak araştırmalar, nüfusun büyük çoğunluğunun aslında **ambivert** olduğunu gösteriyor.

**İçe Dönüklük Yanlış Anlaşılıyor**
İçe dönük olmak utangaç olmak değildir. İçe dönükler sosyal ortamlardan enerji kaybeder ve yalnızlıkta şarj olur. Derin düşünürler, iyi dinleyicilerdir.

**Dışa Dönüklüğün Gücü**
Dışa dönükler sosyal etkileşimden enerji alır. Hızlı karar verir, yeni deneyimlere kolayca adapte olurlar. Ancak derinlik konusunda zorlanabilirler.

**Ambivertlerin Süper Gücü**
Ambivertler her iki dünyadan da en iyisini alır. Hem derin bağlantılar kurabilir hem de kalabalıkta var olabilirler. Bu esneklik, satış, liderlik ve empati gerektiren mesleklerde büyük avantaj sağlar.

**Kendinizi Nasıl Anlarsınız?**
Enerji seviyenizi gözlemleyin: Parti sonrası bitkin mi yoksa enerjik mi hissediyorsunuz? Cevap, spektrumun hangi tarafına yakın olduğunuzu söyler. Ama unutmayın: Kişilik sabit değil, gelişir.
""",
            imageName: "personality_spectrum",
            date: Date(),
            isFeatured: false
        ),
        ReadingArticle(
            id: UUID(),
            title: "Disiplin Özgürlüktür: Alışkanlıkların Gizli Dili",
            subtitle: "Kişisel gelişim",
            category: .development,
            readingMinutes: 6,
            summary: "Her büyük başarı, bilinçsizce yapılan küçük günlük seçimlerin birikmesiyle başlar. Alışkanlık döngüsünü çözmek her şeyi değiştirir.",
            content: """
James Clear'ın "Atomik Alışkanlıklar" kitabında formüle ettiği gibi: Büyük başarılar, küçük alışkanlıkların %1'lik iyileşmelerinin bileşik etkisinden doğar.

**Alışkanlık Döngüsü**
Her alışkanlık dört aşamadan oluşur: İşaret → İstek → Eylem → Ödül. Bu döngüyü anlayan kişi, istemediği alışkanlıkları kırabilir ve istediğini inşa edebilir.

**Kimlik Tabanlı Alışkanlıklar**
"Koşmaya başlamak istiyorum" yerine "Ben bir koşucuyum" diyebilmek, alışkanlığın kalıcı olmasının sırrıdır. Kimliğinizi değiştirdiğinizde, davranışlar kendiliğinden değişir.

**İki Dakika Kuralı**
Yeni bir alışkanlığa başlarken, onu iki dakikadan kısa sürecek şekilde küçültün. "Her gün kitap oku" yerine "Her gün bir sayfa oku." Başlangıç en zor kısımdır; geri kalanı kendiğinden gelir.

**Çevre Tasarımı**
Dikkat dağıtıcıları ortadan kaldırın ve iyi alışkanlıkları kolaylaştırın. Spor ayakkabınızı geceden hazırlayın. Meyveyi masanızın üstüne koyun. Çevre, irade gücünden çok daha güçlüdür.
""",
            imageName: "discipline_habits",
            date: Date(),
            isFeatured: false
        ),
        ReadingArticle(
            id: UUID(),
            title: "Şimdiki Ana Dönmek: Mindfulness'ın Temelleri",
            subtitle: "Mindfulness pratiği",
            category: .mindfulness,
            readingMinutes: 4,
            summary: "Geçmişte yaşamak depresyonu, gelecekte yaşamak kaygıyı besler. Tek gerçek olan şimdiki an, zihinsel sağlığın kalesidir.",
            content: """
Mindfulness, yani bilinçli farkındalık, zihni şimdiki ana sabitlemek demektir. Jon Kabat-Zinn'in 1970'lerde geliştirdiği MBSR (Mindfulness-Based Stress Reduction) programından bu yana bilimsel temeli giderek güçleniyor.

**Otomatik Pilot Sendromu**
Araştırmalar, insanların zamanın yaklaşık %47'sini o anda yaptıkları şeyden başka şeyler düşünerek geçirdiğini gösteriyor. Bu "otomatik pilot" hali, mutsuzluğun birincil kaynağı.

**Gözlemci Zihni Geliştirmek**
Mindfulness, düşüncelerinizi durdurmayı değil, onları gözlemlemeyi öğretir. "Kaygılanıyorum" yerine "Kaygı duygusu ortaya çıktı" demek, sizi duygularınızdan ayırır ve özgürlük yaratır.

**Günlük Mindfulness Pratikleri**
- Sabah kahvenizi içerken yalnızca kahvenize odaklanın
- Yemek yerken telefonu kapatın ve her lokmayı hissedin  
- Yürürken adımlarınızı ve nefesinizi fark edin
- Biri konuşurken gerçekten dinleyin; cevabınızı hazırlamayın

**Beş Duyu Egzersizi**
Stres anında şunları sayın: 5 gördüğünüz şey, 4 dokunduğunuz şey, 3 duyduğunuz şey, 2 kokladığınız şey, 1 tattığınız şey. Bu teknik, zihni anında şimdiye getirir.
""",
            imageName: "mindfulness_present",
            date: Date(),
            isFeatured: false
        ),
        ReadingArticle(
            id: UUID(),
            title: "Uyku: Beynin Gece Yarısı Temizlik Servisi",
            subtitle: "Sağlık & wellness",
            category: .wellness,
            readingMinutes: 5,
            summary: "Uyku bir lüks değil, hayatta kalmak için biyolojik bir zorunluluktur. Kaliteli uyku, zihinsel ve fiziksel sağlığın her boyutunu etkiler.",
            content: """
Matthew Walker'ın "Neden Uyuruz?" kitabı, uyku bilimini herkese açtı. Bulgular şaşırtıcı: Düzenli uyku eksikliği, Alzheimer riskini, kanser olasılığını ve kalp hastalıklarını artırır.

**Glimfatik Sistem: Beynin Çöp Arabası**
Uyku sırasında beyin, sinir hücrelerinin arasındaki mesafeyi genişleterek glimfatik sistemi aktive eder. Bu sistem, gün boyu biriken toksinleri ve Alzheimer'a yol açan beta-amiloid plaklarını temizler.

**REM ve Derin Uyku**
REM uykusunda duygusal anılar işlenir ve yaratıcı bağlantılar kurulur. Derin uyku (Evre 3, NREM) ise fiziksel iyileşme ve öğrendiğimiz bilgilerin kalıcılaşması için kritiktir.

**Uyku Hijyeninin 5 Altın Kuralı**
1. Her gün aynı saatte yatın ve kalkın
2. Yatak odanızı serin tutun (18-20°C ideal)
3. Yatmadan 2 saat önce mavi ışığa maruz kalmayın
4. Kahveyi öğleden sonra keskin
5. Yatak odanızı yalnızca uyku için kullanın

**Kısa Uyku Efsanesi**
"Ben az uyuyabilirim" diyenlerin %97'si aslında kronik uyku yoksunluğuna adapte olmuştur. Gerçek performans için 7-9 saat uyku şarttır.
""",
            imageName: "sleep_wellness",
            date: Date(),
            isFeatured: false
        ),
        ReadingArticle(
            id: UUID(),
            title: "Empati: Duygusal Zekanın Kalbi",
            subtitle: "Kişilik & ilişkiler",
            category: .personality,
            readingMinutes: 4,
            summary: "Empati, başkasının yerine geçmek değil; başkasının hissettiklerini kendi içinde tanımaktır. Bu beceri öğrenilebilir.",
            content: """
Daniel Goleman'ın duygusal zeka çalışmaları, empatinin IQ'dan çok daha güçlü bir başarı belirleyicisi olduğunu ortaya koydu.

**Bilişsel ve Duygusal Empati**
Bilişsel empati, başkasının bakış açısını zihinsel olarak anlamaktır. Duygusal empati ise o hissi gerçekten hissetmektir. Her ikisi de geliştirilebilir ve sağlıklı ilişkiler için ikisine de ihtiyaç vardır.

**Empati Yorgunluğu**
Sürekli başkasının duygularını taşımak tükenmişliğe yol açar. Sağlıklı empati, şefkatli mesafe gerektirir: "Senin acını görüyorum, ama senin acın benim acım değil."

**Empatiyi Geliştirmenin Yolları**
- Yargılamadan dinleme pratiği yapın
- Farklı yaşam deneyimlerini anlatan kitaplar ve filmler izleyin
- "Nasılsın?" sorusunu gerçekten merak ederek sorun
- Sosyal medyada insanları tek boyutlu görmekten kaçının

**İlişkilerde Empati**
En güçlü ilişkiler, "Haklısın veya haksızsın" üzerine değil, "Seni anlıyorum" üzerine kuruludur. Bu tek cümle, çatışmaların büyük çoğunluğunu çözer.
""",
            imageName: "empathy_emotional",
            date: Date(),
            isFeatured: false
        ),
        ReadingArticle(
            id: UUID(),
            title: "Nefes Kontrolü: Anlık Sakinleşmenin Bilimi",
            subtitle: "Meditasyon & nefes",
            category: .meditation,
            readingMinutes: 3,
            summary: "Nefesiniz, sinir sisteminizin anlık kontrol düğmesidir. Doğru teknikle saniyeler içinde stres tepkinizi kapataıblirsiniz.",
            content: """
Otonom sinir sisteminiz genellikle otomatik çalışır; kalp atışınızı ve nefesinizi siz kontrol etmezsiniz. Ama nefes bu sistemin tek bilinçli kapısıdır.

**Vagus Siniri ve Nefes**
Nefesinizi yavaşlatmak, vagus sinirini aktive eder. Bu sinir, "dinlen ve sindir" tepkisini tetikler. Kalp hızı düşer, kaslar gevşer, zihin sakinleşir.

**4-7-8 Tekniği**
1. 4 saniye boyunca burundan nefes alın
2. 7 saniye nefesi tutun
3. 8 saniye boyunca ağızdan verin
Sadece 4 döngü, anksiyeteyi belirgin şekilde azaltır.

**Fizyolojik İç Çekiş**
Stanford araştırmacıları tarafından keşfedilen bu teknik: Burnunuzdan çift nefes alın (bir nefes, ardından anında küçük bir nefes daha) ve ağızdan uzun bir nefes verin. Bu teknik, akciğerlerdeki hava keselerini sıfırlar ve anında rahatlatır.

**Kutu Nefes (Box Breathing)**
Navy SEAL'lerin yüksek stres altında kullandığı teknik: 4 saniye al, 4 saniye tut, 4 saniye ver, 4 saniye bekle. Dörtgen düşünün.

Nefes pratiğinin güzelliği: Her zaman yanınızda, ücretsiz ve saniyeler içinde etkili.
""",
            imageName: "breathing_calm",
            date: Date(),
            isFeatured: false
        ),
        ReadingArticle(
            id: UUID(),
            title: "Büyüme Zihniyeti: Yetenek mi, Çaba mı?",
            subtitle: "Kişisel gelişim",
            category: .development,
            readingMinutes: 5,
            summary: "Carol Dweck'in araştırmaları, zekanın sabit olmadığını kanıtladı. Başarı, yeteneğe değil zihniyet seçimine bağlıdır.",
            content: """
Stanford Psikoloji Profesörü Carol Dweck, onlarca yıllık araştırmasını iki kavrama indirdi: **Sabit Zihniyet** ve **Büyüme Zihniyeti**.

**Sabit Zihniyet**
"Zeki ya doğulur ya doğulmaz." Bu inanç, başarısızlığı kimlik tehdidi olarak algılar. Zorlu görevlerden kaçınır, eleştiriyi kişisel saldırı olarak görür.

**Büyüme Zihniyeti**
"Her şey öğrenilebilir ve geliştirilebilir." Bu inanç, zorluğu fırsat olarak görür. Başarısızlık geri bildirimdir, son değil.

**Beyinde Ne Olur?**
Büyüme zihniyetiyle hatalar yapan kişilerin beyinleri, o hatayı işlemek için daha fazla elektriksel aktivite gösterir. Yani gerçek anlamda daha fazla öğrenirler.

**"Henüz Değil" Gücü**
"Bu konuyu anlamıyorum" yerine "Bu konuyu henüz anlamıyorum" demek, küçük ama devrimsel bir kayıştır. "Henüz" kelimesi, olasılık kapısını açık tutar.

**Pratikte Büyüme Zihniyeti**
- Zorlu görevleri seçin, kolay olanları değil
- Başarıyı çabaya bağlayın, yeteneğe değil
- Eleştiriyi bilgi olarak toplayın
- Başkasının başarısından ilham alın, tehdit hissetmeyin
""",
            imageName: "growth_mindset",
            date: Date(),
            isFeatured: false
        ),
    ]
}

