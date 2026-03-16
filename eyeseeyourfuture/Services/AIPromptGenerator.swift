import Foundation

class AIPromptGenerator {
    
    static func generatePersonalityPrompt(user: User, language: AppLanguage) -> String {
        let name = user.name ?? "Kullanıcı"
        let birthDateStr = user.birthDate != nil ? "Doğum Tarihi: \(formatDate(user.birthDate!))" : ""
        let birthTimeStr = user.birthTime != nil ? "Doğum Saati: \(user.birthTime!)" : ""
        let zodiac = user.zodiacSign ?? "Bilinmiyor"
        let eyeColor = user.eyeColor ?? "Bilinmiyor"
        
        var quizContext = "Kişilik Testi Yanıtları:\n"
        if let quiz = user.personalityQuizResults {
            for (category, result) in quiz {
                quizContext += "- \(category): \(result)\n"
            }
        } else {
            quizContext += "Kullanıcı henüz kişilik testini tamamlamadı.\n"
        }
        
        let languageStr = language.displayName
        
        return """
        Kullanıcı Bilgileri:
        İsim: \(name)
        \(birthDateStr)
        \(birthTimeStr)
        Burç: \(zodiac)
        Göz Rengi: \(eyeColor)
        
        \(quizContext)
        
        Lütfen yukarıdaki bilgiler ve kişilik testi sonuçlarına dayanarak çok detaylı, yaklaşık 2000 kelimelik, derin bir kişilik analizi yap. 
        Cevabını MUTLAKA \(languageStr) dilinde ver.
        
        Dil ve Üslup:
        - Profesyonel bir astrolog ve karakter analisti gibi davran ama dili cana yakın, dostane ve samimi olsun. 
        - Kullanıcı bu satırların tamamen ona özel yazıldığını hissetmeli. 
        - "Canım, cicim" gibi ifadeler kullanma ama bir dost gibi rehberlik et.
        
        Yapı:
        - Yanıtında ASLA "GENEL KİŞİLİK ANALİZİ", "GÜÇLÜ YÖNLER" gibi başlıklar kullanma. Kartta zaten başlık var.
        - Direkt analize ve paragraflara geç. 
        - Analiz doyurucu, edebi bir derinliğe sahip ve akıcı olmalı.
        - Güçlü ve zayıf yönlerden bahsederken bunları metnin doğal akışına yedir veya sadece madde işareti (-) kullan ama başlık atma.
        
        Özel Talimatlar:
        - Kullanıcının burç ve astroloji bilgilerini arka planda yorumla ama metninde ASLA "burcun", "zodyak" veya burç isimlerini kullanma.
        - Analizinde kullanıcının göz rengi (\(eyeColor)) ve iris tarama sonuçlarını temel al ancak bunları kesinlikle birer "slogan" gibi tekrarlama. 
        - "Göz rengi", "iris", "tabaka" gibi kelimeleri TÜM ANALİZ boyunca en fazla 1 veya 2 kez kullan. 
        - Bu vurguyu sadece başlangıçta bir kez, çok zarif ve metaforik bir şekilde yapıp ardından tamamen karakter analizine odaklan.
        - Analiz boyunca sürekli 'gözlerine baktığımda' veya 'irisindeki desenler' gibi ifadelerle okuyucuyu bayma.
        - Asla `*`, `#`, `**` gibi özel markdown işaretleri kullanma. Başlıklar için büyük harf kullanabilirsin. Liste işareti olarak sadece `-` kullan.
        
        Analiz çok uzun, doyurucu ve edebi bir derinliğe sahip olmalı.
        """
    }
    
    static func generateDailyFortunePrompt(user: User, language: AppLanguage) -> String {
        let name = user.name ?? "Kullanıcı"
        let zodiac = user.zodiacSign ?? "Bilinmiyor"
        let languageStr = language.displayName
        
        return """
        Kullanıcı: \(name)
        Burç: \(zodiac)
        
        Lütfen bugün için \(languageStr) dilinde kişiye özel bir günlük fal yaz. 
        
        İçerik kuralları:
        - Geleceğe dair somut tahminlerde bulun.
        - Yaklaşık 20-25 cümle uzunluğunda olsun. 
        - Hem aşk, hem iş, hem de genel enerji durumundan bahset.
        - Tonun cana yakın, dostane ve tamamen kişiye özel olsun.
        - Burç veya astroloji terimlerini asla kullanma.
        - "Göz", "iris" veya "renk" kelimelerini tüm fal boyunca sadece 1 kez, falın başında veya sonunda sembolik olarak kullan. 
        - Falın geri kalanında tamamen günün enerjisine, olaylara ve duygulara odaklan.
        - Asla `*`, `#`, `**` gibi özel markdown işaretleri kullanma. Liste işareti olarak sadece `-` kullan.
        """
    }
    
    static func generateInsightPrompt(type: Fortune.FortuneType, user: User, language: AppLanguage) -> String {
        let name = user.name ?? "Kullanıcı"
        let zodiac = user.zodiacSign ?? "Bilinmiyor"
        let typeStr = type.rawValue.capitalized
        let languageStr = language.displayName
        
        var specificInstruction = ""
        if type == .strengths || type == .weaknesses {
            specificInstruction = "Lütfen bu özellikleri madde madde (bullet points) açıklayarak anlat."
        } else {
            specificInstruction = "Bu alanda ( \(typeStr) ) kullanıcının tüm ömrü boyunca nasıl bir yol izleyeceği, genel hayat çizgisi ve gelecekte onu nelerin beklediğiyle ilgili derin tahminler ve öneriler ekle."
        }
        
        return """
        Kullanıcı: \(name)
        Burç: \(zodiac)
        Kategori: \(typeStr)
        
        Lütfen \(languageStr) dilinde kullanıcının \(typeStr) hayatı üzerine çok derin, samimi ve dostane bir analiz yap. 
        
        Kurallar:
        - \(specificInstruction)
        - Tüm öngörülerinde kullanıcının göz analizini referans al ama 'iris' veya 'göz rengi' kelimelerini TÜM METİN boyunca sadece 1 kez kullan. 
        - Analizin geri kalanında bu kelimeleri asla tekrarlama, doğrudan bilgilere ve rehberliğe geç.
        - Okuyucu sürekli gözlerinden bahsedildiğini hissetmemeli, sadece analizin kaynağının o olduğunu bir kez anlamalı.
        - Yaklaşık 15-20 cümle uzunluğunda olsun.
        - Asla `*`, `#`, `**` gibi özel markdown işaretleri kullanma. Liste işareti olarak sadece `-` kullan.
        - Profesyonel bir vizyoner gibi konuş ama samimiyeti koru.
        """
    }
    
    static func generateWeeklyArticlesPrompt(category: ReadingCategory, language: AppLanguage) -> String {
        let languageStr = language.displayName
        
        return """
        Sen bilge bir yazarsın. Lütfen "\(category.rawValue)" kategorisi altında 4 farklı bilgilendirici makale yaz.
        Cevabını MUTLAKA \(languageStr) dilinde ver.
        
        Makaleler şu özellikleri taşımalıdır:
        1. Her biri 3-5 dakikalık bir okuma süresine (yaklaşık 600-1000 kelime) sahip olmalıdır.
        2. Dil eğitici, ilham verici ve merak uyandırıcı olmalı.
        3. Kategorinin ruhuna uygun (Meditasyon, Kişisel Gelişim, Spiritüalizm vb.) bilimsel araştırmalar veya kadim bilgiler içermeli.
        
        Lütfen cevabı MUTLAKA şu JSON formatında ver (Aşağıdaki JSON yapısına sadık kal, başka hiçbir metin ekleme):
        [
          {
            "title": "Makale Başlığı",
            "subtitle": "Kısa Alt Başlık",
            "readingMinutes": 4,
            "summary": "Makalenin kısa özeti (2-3 cümle)",
            "content": "Makalenin tam metni...",
            "imageName": "SFSymbol_Adı_Veya_Anahtar_Kelime"
          },
          ... (diğer 3 makale)
        ]
        """
    }
    
    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
