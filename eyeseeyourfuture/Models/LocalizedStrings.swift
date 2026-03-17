import Foundation

// MARK: - Localization Key Enum
// One case per unique UI string across the entire app.
enum LKey: String, Codable {

    // MARK: Tab Bar
    case tabHome        = "tab_home"
    case tabReading     = "tab_reading"
    case tabScan        = "tab_scan"
    case tabHistory     = "tab_history"
    case tabSettings    = "tab_settings"

    // MARK: Home
    case homeTitle          = "home_title"
    case homeStrengths      = "home_strengths"
    case homeWeaknesses     = "home_weaknesses"
    case homeDailyFortune   = "home_daily_fortune"
    case homePersonality    = "home_personality"
    case homeTier           = "home_tier"
    case homeGreetingsMorning = "home_greetings_morning"
    case homeGreetingsAfternoon = "home_greetings_afternoon"
    case homeGreetingsEvening = "home_greetings_evening"
    case homeGreetingsNight = "home_greetings_night"
    case homeMysticMorning = "home_mystic_morning"
    case homeMysticAfternoon = "home_mystic_afternoon"
    case homeMysticEvening = "home_mystic_evening"
    case homeMysticNight = "home_mystic_night"

    case homeSeeInsights    = "home_see_insights"
    case homeEyeAnalysis    = "home_eye_analysis"
    case homeFixEyeColor    = "home_fix_eye_color"
    
    case homeInsightLove        = "home_insight_love"
    case homeInsightLoveSub     = "home_insight_love_sub"
    case homeInsightHealth      = "home_insight_health"
    case homeInsightHealthSub   = "home_insight_health_sub"
    case homeInsightWealth      = "home_insight_wealth"
    case homeInsightWealthSub   = "home_insight_wealth_sub"
    case homeInsightCareer      = "home_insight_career"
    case homeInsightCareerSub   = "home_insight_career_sub"
    
    case insightDetailStrengthsTitle = "insight_detail_strengths_title"
    case insightDetailWeaknessesTitle = "insight_detail_weaknesses_title"
    case insightDetailStrengthsHeader = "insight_detail_strengths_header"
    case insightDetailWeaknessesHeader = "insight_detail_weaknesses_header"
    case insightDetailStrengthsAdvice = "insight_detail_strengths_advice"
    case insightDetailWeaknessesAdvice = "insight_detail_weaknesses_advice"
    case insightDetailStrengthsFooter = "insight_detail_strengths_footer"
    case insightDetailWeaknessesFooter = "insight_detail_weaknesses_footer"
    case insightDetailShareMessage   = "insight_detail_share_message"
    case insightDetailGuide          = "insight_detail_guide"
    
    // MARK: Scanner
    case scanTitle          = "scan_title"
    case scanSubtitle       = "scan_subtitle"
    case scanButton         = "scan_button"
    case scanning           = "scanning"
    case scanAnalyzing      = "scan_analyzing"
    case scanWarning        = "scan_warning"
    case scanAligning       = "scan_aligning"

    // MARK: Fortune Result
    case fortuneTitle       = "fortune_title"
    case fortuneSaveClose   = "fortune_save_close"
    case fortuneClose       = "fortune_close"

    // MARK: History
    case historyTitle           = "history_title"
    case historyEmpty           = "history_empty"
    case historyHeaderTitle     = "history_header_title"
    case historyHeaderSubtitle  = "history_header_subtitle"

    // MARK: Settings
    case settingsTitle          = "settings_title"
    case settingsSectionGeneral = "settings_section_general"
    case settingsSectionSupport = "settings_section_support"
    case settingsSectionAccount = "settings_section_account"
    case settingsPersonalInfo   = "settings_personal_info"
    case settingsPersonalInfoSub = "settings_personal_info_sub"
    case settingsFixEyeColor    = "settings_fix_eye_color"
    case settingsFixEyeColorSub = "settings_fix_eye_color_sub"
    case settingsPrivacyPolicy  = "settings_privacy_policy"
    case settingsPrivacyPolicySub = "settings_privacy_policy_sub"
    case settingsRateUs         = "settings_rate_us"
    case settingsRateUsSub      = "settings_rate_us_sub"
    case settingsLogout         = "settings_logout"
    case settingsDeleteAccount  = "settings_delete_account"
    case settingsDeleteConfirmTitle = "settings_delete_confirm_title"
    case settingsDeleteConfirmMessage = "settings_delete_confirm_message"
    case settingsCancel         = "settings_cancel"
    case settingsDelete         = "settings_delete"
    case settingsNotifications  = "settings_notifications"
    case settingsNotifSub       = "settings_notif_sub"
    case settingsPrivacy        = "settings_privacy"
    case settingsPrivacySub     = "settings_privacy_sub"
    case settingsTheme          = "settings_theme"
    case settingsThemeSub       = "settings_theme_sub"
    case settingsLanguage       = "settings_language"
    case settingsLanguageSub    = "settings_language_sub"
    case settingsSubscription   = "settings_subscription"
    case settingsSubscriptionSub = "settings_subscription_sub"
    case settingsHelp           = "settings_help"
    case settingsHelpSub        = "settings_help_sub"
    case settingsDeleteProfile  = "settings_delete_profile"
    case settingsVersion        = "settings_version"
    case settingsSelectLanguage = "settings_select_language"

    // MARK: Premium Banner
    case premiumTitle       = "premium_title"
    case premiumSubtitle    = "premium_subtitle"
    case premiumUpgrade     = "premium_upgrade"

    // MARK: Login
    case loginTitle         = "login_title"
    case loginSubtitle      = "login_subtitle"
    case loginEmail         = "login_email"
    case loginEmailPlaceholder = "login_email_placeholder"
    case loginPassword      = "login_password"
    case loginPasswordPlaceholder = "login_password_placeholder"
    case loginForgot        = "login_forgot"
    case loginEntry         = "login_entry"
    case loginButton        = "login_button"
    case loginOrConnect     = "login_or_connect"
    case loginGoogle        = "login_google"
    case loginInstagram     = "login_instagram"
    case loginApple         = "login_apple"
    case loginNewUser       = "login_new_user"
    case loginRegister      = "login_register"

    // MARK: Reading
    case readingTitle       = "reading_title"
    case readingFeatured    = "reading_featured"
    case readingFeaturedSub = "reading_featured_sub"
    case readingBegin       = "reading_begin"
    case readingMinutes     = "reading_minutes"
    case readingCatAll      = "reading_cat_all"
    case readingCatMed      = "reading_cat_med"
    case readingCatPers     = "reading_cat_pers"
    case readingCatDev      = "reading_cat_dev"
    case readingCatMind     = "reading_cat_mind"
    case readingCatWell     = "reading_cat_well"
    case readingCatSpir     = "reading_cat_spir"
    case readingCatAstro    = "reading_cat_astro"
    case readingEmpty       = "reading_empty"
    case readingToday       = "reading_today"
    
    // MARK: Setup
    case setupTitle         = "setup_title"
    case setupSubtitle      = "setup_subtitle"
    case setupFullName      = "setup_full_name"
    case setupFullNamePlaceholder = "setup_full_name_placeholder"
    case setupBirthDate     = "setup_birth_date"
    case setupBirthTime     = "setup_birth_time"
    case setupPersonalityTest = "setup_personality_test"
    case setupQuestion      = "setup_question"
    case setupContinue      = "setup_continue"
    case setupStep          = "setup_step"
    case setupNavTitle      = "setup_nav_title"
    
    case quizTitle          = "quiz_title"
    case quizSubtitle       = "quiz_subtitle"
    case quizYes           = "quiz_yes"
    case quizNo            = "quiz_no"
    
    // MARK: Notifications
    case notifTitle        = "notif_title"
    case notifDaily        = "notif_daily"
    case notifInactivity   = "notif_inactivity"
    case notifMonthly      = "notif_monthly"
    case notifFortuneReady = "notif_fortune_ready"
    
    // MARK: Widget & Themes
    case widgetHeader      = "widget_header"
    case themeLove         = "theme_love"
    case themeFriendship   = "theme_friendship"
    case themeFamily       = "theme_family"
    case themePeace        = "theme_peace"
    case themeAnxiety      = "theme_anxiety"
    case themeExcitement   = "theme_excitement"
    case themeSports       = "theme_sports"
    case themeEntertainment = "theme_entertainment"
    case themeWork         = "theme_work"
    case themeEducation    = "theme_education"
    
    // MARK: Developer
    case settingsDevSection = "settings_dev_section"
    case settingsTestNotif  = "settings_test_notif"
    case settingsTestWidget = "settings_test_widget"
    
    // MARK: Premium Locks
    case premiumLockedTitle = "premium_locked_title"
    case premiumLockedDesc  = "premium_locked_desc"
    case premiumLockedButton = "premium_locked_button"
    case premiumStatus      = "premium_status"
    
    // MARK: Alerts
    case alertError         = "alert_error"
    case alertOk            = "alert_ok"
    case loginNewHere       = "login_new_here"
    case registerTitle      = "register_title"
    case registerSubtitle   = "register_subtitle"
    case registerFullName   = "register_full_name"
    case registerFullNamePlaceholder = "register_full_name_placeholder"
    case registerEmailPlaceholder = "register_email_placeholder"
    case registerPasswordMismatch = "register_password_mismatch"
    case registerAlreadyHaveAccount = "register_already_have_account"
    case registerNavTitle   = "register_nav_title"
    
    // MARK: Contact Us
    case contactTitle       = "contact_title"
    case contactSubtitle    = "contact_subtitle"
    case contactName        = "contact_name"
    case contactEmail       = "contact_email"
    case contactSubject     = "contact_subject"
    case contactMessage     = "contact_message"
    case contactSend        = "contact_send"
    case contactSuccess     = "contact_success"
    case contactSuccessSub  = "contact_success_sub"
    
    // MARK: Fortune Results
    case fortuneDaily       = "fortune_daily"
    case fortunePersonality = "fortune_personality"
    case fortuneShareMessage = "fortune_share_message"
    case fortuneGuide       = "fortune_guide"
    case fortuneGuideMotto  = "fortune_guide_motto"
    
    // MARK: History
    case historyContinueReading = "history_continue_reading"
    
    // MARK: Reading
    case readingMinutesSub  = "reading_minutes_sub"
    case personalityGuideAdvice = "personality_guide_advice"
}

// MARK: - Translations Dictionary
struct LocalizedStrings {
    static let translations: [AppLanguage: [LKey: String]] = [

        // ──────────────────────────────────────────
        // MARK: Turkish
        // ──────────────────────────────────────────
        .turkish: [
            .tabHome:        "Ana Sayfa",
            .tabReading:     "Okuma",
            .tabScan:        "Göz Tara",
            .tabHistory:     "Beğenilenler",
            .tabSettings:    "Ayarlar",

            .homeTitle:       "Oracle Profili",
            .homeStrengths:   "Güçlü Yönler",
            .homeWeaknesses:  "Zayıf Yönler",
            .homeDailyFortune:"GÜNLÜK FALINI GÖR",
            .homePersonality: "KİŞİLİK ANALİZİNİ GÖR",
            .homeTier:        "SEVİYE IV GİZEMCİ",
            .homeGreetingsMorning: "GÜNAYDIN",
            .homeGreetingsAfternoon: "İYİ GÜNLER",
            .homeGreetingsEvening: "İYİ AKŞAMLAR",
            .homeGreetingsNight: "İYİ GECELER",
            .homeMysticMorning: "Güneşin doğuşuyla evrenin kapıları aralanıyor, ruhun ışığa kavuşuyor.",
            .homeMysticAfternoon: "Günün en parlak anında kadim bilgiler zihnine akmaya başlıyor.",
            .homeMysticEvening: "Yıldızlar gökyüzüne yerleşirken gizemli mesajlar sezgilerine ulaşıyor.",
            .homeMysticNight: "Gecenin derinliğinde yıldızlar parlıyor, sana rehberlik eden mesajlar fısıldıyorlar.",
            .homeSeeInsights: "Görüntüle",
            .homeEyeAnalysis: "Göz Analizi",

            .homeInsightLove:         "Aşk & İlişkiler",
            .homeInsightLoveSub:      "Uyum Analizi",
            .homeInsightHealth:       "Canlılık & Sağlık",
            .homeInsightHealthSub:    "Enerji Durumu",
            .homeInsightWealth:       "Refah & Bolluk",
            .homeInsightWealthSub:    "Maddi Şans",
            .homeInsightCareer:       "Kariyer & Hedefler",
            .homeInsightCareerSub:    "Gelecek Planı",

            .insightDetailStrengthsTitle: "Güçlü Yönlerin",
            .insightDetailWeaknessesTitle: "Zayıf Yönlerin",
            .insightDetailStrengthsHeader: "GÜÇLÜ YÖNLER",
            .insightDetailWeaknessesHeader: "ZAYIF YÖNLER",
            .insightDetailStrengthsAdvice: "Kozmik güçler ve yıldızların fısıltısı senin bu eşsiz yeteneklerini destekliyor. Bu parlak yönlerini hayatının her alanına yaymak, sadece senin için değil, çevrendekiler için de bir ışık kaynağı olacaktır. İçindeki bu gücü fark etmek, ruhsal yolculuğunda atacağın en önemli adımlardan biridir. Gökyüzündeki hizalanmalar senin bu potansiyelini en yüksek seviyeye çıkarmak için uygun bir zemin hazırlıyor. Kendine olan güvenini bu güçlerden alarak, karşına çıkan her türlü engeli zarafetle aşabileceğini unutma. Evrenin enerjisini bu yönlerine kanalize ettiğinde, mucizelerin gerçekleşmeye başladığını göreceksin. Şansın ve bilgeliğin her daim seninle olsun.",
            .insightDetailWeaknessesAdvice: "Zayıf yönlerini cesaretle kabul etmek, onları sarsılmaz bir güce dönüştürmenin ilk ve en kutsal adımıdır. Her bir eksiklik, aslında ruhunun tamamlanmayı bekleyen bir parçası ve öğrenilmesi gereken bir dersidir. Evren sana bu alanlarda gelişim göstermen için sürekli olarak küçük rehberlikler ve fırsatlar sunuyor. Bu yönlerinin farkında olmak, hayatındaki dengeyi kurmanı ve daha sağlam kararlar almanı sağlayacaktır. Kendine karşı şefkatli ol ama bu yönlerini geliştirmek için gereken iradeyi de içinden çıkar. Unutma ki en büyük elmaslar, en yüksek baskı altında ve karanlığın içinde şekillenir. Yıldızlar, senin bu dönüşüm sürecinde her zaman yanında olacak ve yolunu aydınlatacaktır.",
            .insightDetailStrengthsFooter: "Işığını parlatmaya devam et.",
            .insightDetailWeaknessesFooter: "Farkındalık dönüşümün ilk adımıdır.",
            .insightDetailShareMessage:   "EyeSeesYourFuture ile ruhsal kimliğimi keşfettim!",
            .insightDetailGuide:          "REHBER",

            .scanTitle:       "Gözünü Tarat",
            .scanSubtitle:    "Yapay zeka göz irisine bakarak kaderini okuyacak.",
            .scanButton:      "Taramayı Başlat",
            .scanning:        "Taranıyor...",
            .scanAnalyzing:   "Analiz ediliyor...",
            .scanWarning:     "Not: Lütfen gözünüzü kadraja tam ortalayın ve yeterli ışık olduğundan emin olun. Hatalı sonuç almamak için bu önemlidir.",
            .scanAligning:    "Göz hizalanıyor...",

            .fortuneTitle:    "Yapay Zeka Okuması",
            .fortuneSaveClose:"Kaydet ve Kapat",
            .fortuneClose:    "Kapat",

            .historyTitle:    "Beğenilenler",
            .historyEmpty:    "Henüz beğendiğiniz bir fal yok.",
            .historyHeaderTitle: "Yıldızların Gizli Defteri",
            .historyHeaderSubtitle: "Evrenin fısıldadığı her bir söz, kalbinde saklı birer mücevherdir.",

            .settingsTitle:           "Mistik Ayarlar",
            .settingsSectionGeneral:  "GENEL DENEYİM",
            .settingsSectionSupport:  "DESTEK & YASAL",
            .settingsSectionAccount:  "HESAP VE VERİ",
            .settingsPersonalInfo:    "Kişisel Bilgiler",
            .settingsPersonalInfoSub: "Ad, doğum tarihi ve kişilik verileri",
            .settingsFixEyeColor:     "Göz Rengimi Düzelt",
            .homeFixEyeColor:         "Göz Analizimi Düzelt",
            .settingsFixEyeColorSub:  "Yanlış belirlendiyse talep oluşturun",
            .settingsPrivacyPolicy:   "Gizlilik Politikası",
            .settingsPrivacyPolicySub: "Verilerinizin nasıl korunduğunu görün",
            .settingsRateUs:          "Bizi Değerlendir",
            .settingsRateUsSub:       "App Store\'da yorum bırakın",
            .settingsLogout:          "Çıkış Yap",
            .settingsDeleteAccount:   "Hesabı Sil",
            .settingsDeleteConfirmTitle: "Hesabı Sil",
            .settingsDeleteConfirmMessage: "Profilinizi silmek istediğinize emin misiniz? Tüm verileriniz kalıcı olarak silinecektir.",
            .settingsCancel:          "Vazgeç",
            .settingsDelete:          "Sil",
            .settingsNotifications:   "Bildirim Ayarları",
            .settingsNotifSub:        "Günlük okumalar ve kozmik uyarılar",
            .settingsPrivacy:         "Hesap Gizliliği",
            .settingsPrivacySub:      "Ruhsal verilerini kontrol et",
            .settingsTheme:           "Tema Seçimi",
            .settingsThemeSub:        "Arayüz stilini özelleştir",
            .settingsLanguage:        "Dil",
            .settingsLanguageSub:     "Uygulama dilini değiştir",
            .settingsSubscription:    "Abonelik",
            .settingsSubscriptionSub: "Premium planını yönet",
            .settingsHelp:            "Yardım Merkezi",
            .settingsHelpSub:         "Orakullar yardım etmeye hazır",
            .settingsDeleteProfile:   "Kozmik Profili Sil",
            .settingsVersion:         "UYGULAMA SÜRÜMÜ 2.4.0 (STELLAR)",
            .settingsSelectLanguage:  "Dil Seç",

            .premiumTitle:    "Celestial Premium",
            .premiumSubtitle: "Günlük detaylı burç yorumlarının ve gezegen hizalamalarının kilidini aç.",
            .premiumUpgrade:  "Şimdi Yükselt",

            .loginTitle:              "Kaderini Aç",
            .loginSubtitle:           "Yıldızlar hikayeni yazdı. Okumak için giriş yap.",
            .loginEmail:              "E-posta Adresi",
            .loginEmailPlaceholder:   "Kozmik e-postanı gir",
            .loginPassword:           "Şifre",
            .loginPasswordPlaceholder:"Gizli anahtarını gir",
            .loginForgot:             "Şifremi Unuttum",
            .loginEntry:              "Giriş Yap",
            .loginButton:             "Orakla Danış",
            .loginOrConnect:          "VEYA BAĞLAN",
            .loginGoogle:             "Google ile Devam Et",
            .loginInstagram:          "Instagram ile Devam Et",
            .loginApple:              "Apple ile Devam Et",
            .loginNewUser:            "Kozmosa yeni misin?",
            .loginRegister:           "Kaydol",

            .readingTitle:    "Günlük Okuma",
            .readingFeatured: "Öne Çıkan",
            .readingFeaturedSub: "Bugün",
            .readingBegin:    "Okumaya Başla",
            .readingMinutes:  "dk okuma",
            .readingCatAll:   "Tümü",
            .readingCatMed:   "Meditasyon",
            .readingCatPers:  "Kişilik",
            .readingCatDev:   "Gelişim",
            .readingCatMind:  "Mindfulness",
            .readingCatWell:    "Sağlık",
            .readingCatSpir:    "Spiritüalizm",
            .readingCatAstro:   "Astroloji",
            .readingEmpty:    "Bu kategoride bugün içerik yok",
            .readingToday:    "Bugün",
            
            .setupTitle:         "Kader Haritanı Çiz",
            .setupSubtitle:      "Büyüklerimiz bu detayları yıldızlarını hizalamak için kullanır.",
            .setupFullName:      "Tam Ad",
            .setupFullNamePlaceholder: "Örn. Alexander Orion",
            .setupBirthDate:     "Doğum Tarihi",
            .setupBirthTime:     "Tam Doğum Saati",
            .setupPersonalityTest: "KİŞİLİK TESTİ",
            .setupQuestion:      "Hangi elemente kendinizi en yakın hissediyorsunuz?",
            .setupContinue:      "Yolculuğa Devam Et",
            .setupStep:          "Adım 1 / 3: Ruhsal Hizalanma",
            .setupNavTitle:      "Yıldız Haritası Kurulumu",
            
            .quizTitle:          "Kişilik Analizi",
            .quizSubtitle:       "Seni daha yakından tanımamıza yardımcı ol.",
            .quizYes:            "Evet",
            .quizNo:             "Hayır",
            
            .notifTitle:         "Gelecekten Haber Var",
            .notifDaily:         "Bakalım bugün seni neler bekliyor 👁️",
            .notifInactivity:    "Merak ediyorum. Sen etmiyor musun? ✨",
            .notifMonthly:       "Bu ay seni nelerin beklediğini sana söylemeliyim. 👁️",
            .notifFortuneReady:   "Günlük falın hazır ✨",
            
            .widgetHeader:       "Günün Teması:",
            .themeLove:          "AŞK",
            .themeFriendship:    "ARKADAŞLIK",
            .themeFamily:        "AİLE",
            .themePeace:         "HUZUR",
            .themeAnxiety:       "ENDİŞE",
            .themeExcitement:    "HEYECAN",
            .themeSports:        "SPOR",
            .themeEntertainment:  "EĞLENCE",
            .themeWork:          "İŞ",
            .themeEducation:     "EĞİTİM",
            
            .settingsDevSection: "GELİŞTİRİCİ TESTLERİ",
            .settingsTestNotif:  "Bildirimleri Test Et",
            .settingsTestWidget: "Widget Temasını Değiştir",
            
            .premiumLockedTitle:  "Celestial Erişim Kilitli",
            .premiumLockedDesc:   "Bu özel analizi ve kozmik rehberliği görüntülemek için Premium'a yükseltin.",
            .premiumLockedButton: "Kilidi Hemen Aç",
            .premiumStatus:       "Premium Durumu",
            .alertError:          "Hata",
            .alertOk:             "Tamam",
            .loginNewHere:        "Burada yeni misin?",
            .registerTitle:       "Yolculuğuna Başla",
            .registerSubtitle:    "Yıldızların senin için ne sakladığını öğrenmek için bilgilerini gir.",
            .registerFullName:    "Tam Ad",
            .registerFullNamePlaceholder: "Adını gir",
            .registerEmailPlaceholder: "ruhun@kozmos.com",
            .registerPasswordMismatch: "Şifreler eşleşmiyor.",
            .registerAlreadyHaveAccount: "Zaten bir hesabın var mı?",
            .registerNavTitle:     "Göksel Rehberlik",
            
            .contactTitle:        "Bize Ulaşın",
            .contactSubtitle:     "Göz renginiz yanlış belirlendiyse veya bir geri bildiriminiz varsa bize yazın.",
            .contactName:         "Ad Soyad",
            .contactEmail:        "Apple ID E-posta",
            .contactSubject:      "Konu",
            .contactMessage:      "Mesajınız",
            .contactSend:         "Gönder",
            .contactSuccess:      "Mesajınız Gönderildi",
            .contactSuccessSub:   "Geri bildiriminiz için teşekkür ederiz. Kozmik ekibimiz en kısa sürede sizinle iletişime geçecektir.",
            
            .fortuneDaily:        "Günlük Falın",
            .fortunePersonality:  "Kişilik Analizin",
            .fortuneShareMessage: "EyeSeesYourFuture ile kaderimi keşfettim!",
            .fortuneGuide:        "KOZMİK REHBER",
            .fortuneGuideMotto:   "Evrenin fısıltılarını dinle, kalbinin sesini takip et.",
            
            .historyContinueReading: "OKUMAYA DEVAM ET",
            
            .readingMinutesSub:   "dk",
            .personalityGuideAdvice: "Kendini keşfetme yolculuğun, evrenin sana sunduğu en değerli hazinedir. Bu analizdeki her bir cümle, içindeki gizli potansiyeli uyandırmak ve gerceğe dönüştürmek için bir anahtardır. Hayatının bu evresinde karşına çıkan her zorluk, aslında ruhunun gelişimi için tasarlanmış özel birer basamaktır. Kendi iç sesine güvenmeyi öğrendikçe, dış dünyanın karmaşası yerini derin bir huzura ve netliğe bırakacaktır. Yıldızların ve irisin fısıldadığı bu bilgilerle yolunu aydınlatırken, her adımında daha cesur ve bilinçli ilerleyeceksin. Unutma ki sen, kendi kaderinin hem yazarı hem de başrol oyuncususun. Işığını parlatmaya devam ettikçe, evren de senin için yeni kapılar açmaya devam edecektir.",
        ],

        // ──────────────────────────────────────────
        // MARK: English
        // ──────────────────────────────────────────
        .english: [
            .tabHome:        "Home",
            .tabReading:     "Reading",
            .tabScan:        "Scan Eye",
            .tabHistory:     "History",
            .tabSettings:    "Settings",

            .homeTitle:       "Oracle Profile",
            .homeStrengths:   "Strengths",
            .homeWeaknesses:  "Weaknesses",
            .homeDailyFortune:"VIEW DAILY FORTUNE",
            .homePersonality: "VIEW PERSONALITY ANALYSIS",
            .homeTier:        "TIER IV MYSTIC",
            .homeGreetingsMorning: "GOOD MORNING",
            .homeGreetingsAfternoon: "GOOD DAY",
            .homeGreetingsEvening: "GOOD EVENING",
            .homeGreetingsNight: "GOOD NIGHT",
            .homeMysticMorning: "With the sunrise, the gates of the universe open, your soul finds light.",
            .homeMysticAfternoon: "At the brightest moment of the day, ancient wisdom begins to flow into your mind.",
            .homeMysticEvening: "As the stars settle in the sky, mysterious messages reach your intuition.",
            .homeMysticNight: "In the depths of the night, the stars shine, whispering messages that guide you.",
            .homeSeeInsights: "View",
            .homeEyeAnalysis: "Eye Analysis",

            .homeInsightLove:         "Love & Relationships",
            .homeInsightLoveSub:      "Harmony Analysis",
            .homeInsightHealth:       "Vitality & Health",
            .homeInsightHealthSub:    "Energy State",
            .homeInsightWealth:       "Wealth & Abundance",
            .homeInsightWealthSub:    "Financial Luck",
            .homeInsightCareer:       "Career & Goals",
            .homeInsightCareerSub:    "Future Plan",

            .insightDetailStrengthsTitle: "Your Strengths",
            .insightDetailWeaknessesTitle: "Your Weaknesses",
            .insightDetailStrengthsHeader: "STRENGTHS",
            .insightDetailWeaknessesHeader: "WEAKNESSES",
            .insightDetailStrengthsAdvice: "Cosmic powers and the whispers of the stars support these unique talents of yours. Spreading these brilliant aspects to every area of your life will be a source of light not only for you but also for those around you. Recognizing this inner power is one of the most important steps in your spiritual journey. The alignments in the sky are preparing a suitable ground for you to reach the highest level of this potential. Never forget that by taking your self-confidence from these powers, you can overcome every obstacle you encounter with grace. When you channel the energy of the universe into these directions, you will see miracles begin to happen. May luck and wisdom always be with you.",
            .insightDetailWeaknessesAdvice: "Courageously accepting your weaknesses is the first and most sacred step in turning them into an unshakable strength. Every shortcoming is actually a part of your soul waiting to be completed and a lesson to be learned. The universe constantly offers small guidances and opportunities for you to grow in these areas. Being aware of these aspects will allow you to establish balance in your life and make more solid decisions. Be compassionate towards yourself but also find the will to develop these areas within you. Remember that the greatest diamonds are shaped under the highest pressure and in darkness. The stars will always be by your side during this transformation process and will light your way.",
            .insightDetailStrengthsFooter: "Keep shining your light.",
            .insightDetailWeaknessesFooter: "Awareness is the first step of transformation.",
            .insightDetailShareMessage:   "I discovered my spiritual identity with EyeSeesYourFuture!",
            .insightDetailGuide:          "GUIDE",

            .scanTitle:       "Scan Your Eye",
            .scanSubtitle:    "AI will read your destiny through your iris.",
            .scanButton:      "Start Scan",
            .scanning:        "Scanning...",
            .scanAnalyzing:   "Analyzing...",
            .scanWarning:     "Note: Please center your eye in the frame and ensure enough light for an accurate analysis.",
            .scanAligning:    "Aligning eye...",

            .fortuneTitle:    "AI Reading",
            .fortuneSaveClose:"Save & Close",
            .fortuneClose:    "Close",

            .historyTitle:    "Fortune History",
            .historyEmpty:    "No saved fortunes yet.",
            .historyHeaderTitle: "The Stars' Secret Journal",
            .historyHeaderSubtitle: "Every word whispered by the universe is a jewel hidden in your heart.",

            .settingsTitle:           "Mystic Settings",
            .settingsSectionGeneral:  "GENERAL EXPERIENCE",
            .settingsSectionSupport:  "SUPPORT & LEGAL",
            .settingsSectionAccount:  "ACCOUNT AND DATA",
            .settingsPersonalInfo:    "Personal Information",
            .settingsPersonalInfoSub: "Name, birth date, and personality data",
            .settingsFixEyeColor:     "Fix My Eye Color",
            .homeFixEyeColor:         "Fix My Eye Analysis",
            .settingsFixEyeColorSub:  "Create a request if identified incorrectly",
            .settingsPrivacyPolicy:   "Privacy Policy",
            .settingsPrivacyPolicySub: "See how your data is protected",
            .settingsRateUs:          "Rate Us",
            .settingsRateUsSub:       "Leave a review on the App Store",
            .settingsLogout:          "Log Out",
            .settingsDeleteAccount:   "Delete Account",
            .settingsDeleteConfirmTitle: "Delete Account",
            .settingsDeleteConfirmMessage: "Are you sure you want to delete your profile? All your data will be permanently deleted.",
            .settingsCancel:          "Cancel",
            .settingsDelete:          "Delete",
            .settingsNotifications:   "Notification Settings",
            .settingsNotifSub:        "Daily readings & cosmic alerts",
            .settingsPrivacy:         "Account Privacy",
            .settingsPrivacySub:      "Control your spiritual data",
            .settingsTheme:           "Theme Selection",
            .settingsThemeSub:        "Customize your interface vibes",
            .settingsLanguage:        "Language",
            .settingsLanguageSub:     "Change the app language",
            .settingsSubscription:    "Subscription",
            .settingsSubscriptionSub: "Manage your premium plan",
            .settingsHelp:            "Help Center",
            .settingsHelpSub:         "Oracles are here to help",
            .settingsDeleteProfile:   "Delete Cosmic Profile",
            .settingsVersion:         "APP VERSION 2.4.0 (STELLAR)",
            .settingsSelectLanguage:  "Select Language",

            .premiumTitle:    "Celestial Premium",
            .premiumSubtitle: "Unlock daily detailed horoscopes and planetary alignments.",
            .premiumUpgrade:  "Upgrade Now",

            .loginTitle:              "Unlock Your Destiny",
            .loginSubtitle:           "The stars have written your story. Sign in to read it.",
            .loginEmail:              "Email Address",
            .loginEmailPlaceholder:   "Enter your celestial email",
            .loginPassword:           "Password",
            .loginPasswordPlaceholder:"Enter your secret key",
            .loginForgot:             "Forgot Password",
            .loginEntry:              "Log In",
            .loginButton:             "Consult the Oracle",
            .loginOrConnect:          "OR CONNECT VIA",
            .loginGoogle:             "Continue with Google",
            .loginInstagram:          "Continue with Instagram",
            .loginApple:              "Continue with Apple",
            .loginNewUser:            "New to the cosmos?",
            .loginRegister:           "Register Now",

            .readingTitle:    "Daily Reading",
            .readingFeatured: "Featured",
            .readingFeaturedSub: "Today",
            .readingBegin:    "Begin Reading",
            .readingMinutes:  "min read",
            .readingCatAll:   "All",
            .readingCatMed:   "Meditation",
            .readingCatPers:  "Personality",
            .readingCatDev:   "Development",
            .readingCatMind:  "Mindfulness",
            .readingCatWell:    "Wellness",
            .readingCatSpir:    "Spiritualism",
            .readingCatAstro:   "Astrology",
            .readingEmpty:    "No content in this category today",
            .readingToday:    "Today",
            
            .setupTitle:         "Map Your Destiny",
            .setupSubtitle:      "Our elders use these details to align your stars.",
            .setupFullName:      "Full Name",
            .setupFullNamePlaceholder: "E.g. Alexander Orion",
            .setupBirthDate:     "Birth Date",
            .setupBirthTime:     "Exact Birth Time",
            .setupPersonalityTest: "PERSONALITY TEST",
            .setupQuestion:      "Which element do you feel most connected to?",
            .setupContinue:      "Continue Journey",
            .setupStep:          "Step 1 of 3: Spiritual Alignment",
            .setupNavTitle:      "Birth Chart Setup",
            
            .quizTitle:          "Personality Analysis",
            .quizSubtitle:       "Help us get to know you better.",
            .quizYes:            "Yes",
            .quizNo:             "No",
            
            .notifTitle:         "News from the Future",
            .notifDaily:         "Let's see what awaits you today 👁️",
            .notifInactivity:    "I'm curious. Aren't you? ✨",
            .notifMonthly:       "I must tell you what awaits you this month. 👁️",
            .notifFortuneReady:   "Your daily fortune is ready ✨",
            
            .widgetHeader:       "Daily Theme:",
            .themeLove:          "LOVE",
            .themeFriendship:    "FRIENDSHIP",
            .themeFamily:        "FAMILY",
            .themePeace:         "PEACE",
            .themeAnxiety:       "ANXIETY",
            .themeExcitement:    "EXCITEMENT",
            .themeSports:        "SPORTS",
            .themeEntertainment:  "ENTERTAINMENT",
            .themeWork:          "WORK",
            .themeEducation:     "EDUCATION",
            
            .settingsDevSection: "DEVELOPER TESTS",
            .settingsTestNotif:  "Test Notifications",
            .settingsTestWidget: "Change Widget Theme",
            
            .premiumLockedTitle:  "Celestial Access Locked",
            .premiumLockedDesc:   "Upgrade to Premium to view this detailed analysis and cosmic guidance.",
            .premiumLockedButton: "Unlock Now",
            .premiumStatus:       "Premium Status",
            .alertError:          "Error",
            .alertOk:             "OK",
            .loginNewHere:        "New here?",
            .registerTitle:       "Begin Your Journey",
            .registerSubtitle:    "Enter your details to reveal what the stars have in store for you.",
            .registerFullName:    "Full Name",
            .registerFullNamePlaceholder: "Enter your name",
            .registerEmailPlaceholder: "your.soul@cosmos.com",
            .registerPasswordMismatch: "Passwords do not match.",
            .registerAlreadyHaveAccount: "Already have an account?",
            .registerNavTitle:     "Celestial Guidance",
            
            .contactTitle:        "Contact Us",
            .contactSubtitle:     "Write to us if your eye color was identified incorrectly or if you have feedback.",
            .contactName:         "Full Name",
            .contactEmail:        "Apple ID Email",
            .contactSubject:      "Subject",
            .contactMessage:      "Your Message",
            .contactSend:         "Send",
            .contactSuccess:      "Message Sent",
            .contactSuccessSub:   "Thank you for your feedback. Our cosmic team will contact you as soon as possible.",
            
            .fortuneDaily:        "Daily Fortune",
            .fortunePersonality:  "Personality Analysis",
            .fortuneShareMessage: "I discovered my destiny with EyeSeesYourFuture!",
            .fortuneGuide:        "COSMIC GUIDE",
            .fortuneGuideMotto:   "Listen to the whispers of the universe, follow the voice of your heart.",
            
            .historyContinueReading: "CONTINUE READING",
            .personalityGuideAdvice: "Your journey of self-discovery is the most precious treasure the universe has ever offered you. Every sentence in this analysis is a golden key designed to awaken and transform your hidden potential into reality. Every challenge you encounter at this stage of your life is actually a stepping stone specially crafted for your soul's growth. As you learn to trust your own inner voice, the chaos of the outside world will give way to a profound sense of peace and clarity. By lighting your path with these insights whispered by the stars and your iris, you will move forward with more courage and awareness. Never forget that you are both the author and the lead actor of your own destiny. As you continue to shine your light, the universe will continue to open new doors of opportunity for you.",
            
            .readingMinutesSub:   "min",
        ],

        // ──────────────────────────────────────────
        // MARK: French
        // ──────────────────────────────────────────
        .french: [
            .tabHome:        "Accueil",
            .tabReading:     "Lecture",
            .tabScan:        "Scanner",
            .tabHistory:     "Historique",
            .tabSettings:    "Réglages",

            .homeTitle:       "Profil Oracle",
            .homeStrengths:   "Points forts",
            .homeWeaknesses:  "Points faibles",
            .homeDailyFortune:"VOIR LA FORTUNE DU JOUR",
            .homePersonality: "VOIR L'ANALYSE DE PERSONNALITÉ",
            .homeTier:        "MYSTIQUE NIVEAU IV",
            .homeGreetingsMorning: "BONJOUR",
            .homeGreetingsAfternoon: "BONNE JOURNÉE",
            .homeGreetingsEvening: "BONSOIR",
            .homeGreetingsNight: "BONNE NUIT",
            .homeMysticMorning: "Avec le lever du soleil, les portes de l'univers s'ouvrent, votre âme trouve la lumière.",
            .homeMysticAfternoon: "Au moment le plus brillant de la journée, la sagesse ancienne commence à couler dans votre esprit.",
            .homeMysticEvening: "Alors que les étoiles s'installent dans le ciel, des messages mystérieux atteignent votre intuition.",
            .homeMysticNight: "Dans les profondeurs de la nuit, les étoiles brillent, murmurant des messages qui vous guident.",

            .scanTitle:       "Scannez votre œil",
            .scanSubtitle:    "L'IA lira votre destinée dans votre iris.",
            .scanButton:      "Lancer le scan",
            .scanning:        "Scan en cours...",
            .scanAnalyzing:   "Analyse en cours...",

            .fortuneTitle:    "Lecture IA",
            .fortuneSaveClose:"Sauvegarder & Fermer",
            .fortuneClose:    "Fermer",

            .historyTitle:    "Historique des fortunes",
            .historyEmpty:    "Aucune fortune sauvegardée pour l'instant.",

            .settingsTitle:           "Paramètres mystiques",
            .settingsSectionGeneral:  "EXPÉRIENCE GÉNÉRALE",
            .settingsSectionSupport:  "SUPPORT & LÉGAL",
            .settingsSectionAccount:  "COMPTE ET DONNÉES",
            .settingsLogout:          "Se déconnecter",
            .settingsDeleteAccount:   "Supprimer le compte",
            .settingsNotifications:   "Paramètres de notification",
            .settingsNotifSub:        "Lectures quotidiennes & alertes cosmiques",
            .settingsPrivacy:         "Confidentialité du compte",
            .settingsPrivacySub:      "Contrôlez vos données spirituelles",
            .settingsTheme:           "Sélection du thème",
            .settingsThemeSub:        "Personnalisez votre interface",
            .settingsLanguage:        "Langue",
            .settingsLanguageSub:     "Changer la langue de l'application",
            .settingsSubscription:    "Abonnement",
            .settingsSubscriptionSub: "Gérez votre plan premium",
            .settingsHelp:            "Centre d'aide",
            .settingsHelpSub:         "Les oracles sont là pour vous aider",
            .settingsDeleteProfile:   "Supprimer le profil cosmique",
            .settingsVersion:         "VERSION 2.4.0 (STELLAIRE)",
            .settingsSelectLanguage:  "Sélectionner la langue",

            .premiumTitle:    "Céleste Premium",
            .premiumSubtitle: "Débloquez les horoscopes détaillés et les alignements planétaires.",
            .premiumUpgrade:  "Mettre à niveau",

            .loginTitle:              "Révélez votre destinée",
            .loginSubtitle:           "Les étoiles ont écrit votre histoire. Connectez-vous pour la lire.",
            .loginEmail:              "Adresse e-mail",
            .loginEmailPlaceholder:   "Entrez votre e-mail céleste",
            .loginPassword:           "Mot de passe",
            .loginPasswordPlaceholder:"Entrez votre clé secrète",
            .loginForgot:             "Mot de passe oublié ?",
            .loginButton:             "Consulter l'oracle",
            .loginOrConnect:          "OU SE CONNECTER VIA",
            .loginGoogle:             "Continuer avec Google",
            .loginInstagram:          "Continuer avec Instagram",
            .loginApple:              "Continuer avec Apple",
            .loginNewUser:            "Nouveau dans le cosmos ?",
            .loginRegister:           "S'inscrire maintenant",

            .readingTitle:    "Lecture quotidienne",
            .readingFeatured: "En vedette",
            .readingFeaturedSub: "Aujourd'hui",
            .readingBegin:    "Commencer la lecture",
            .readingMinutes:  "min de lecture",
            .readingCatAll:   "Tout",
            .readingCatMed:   "Méditation",
            .readingCatPers:  "Personnalité",
            .readingCatDev:   "Développement",
            .readingCatMind:  "Pleine conscience",
            .readingCatWell:  "Bien-être",
            .readingEmpty:    "Aucun contenu dans cette catégorie aujourd'hui",
            .readingToday:    "Aujourd'hui",
            .historyHeaderTitle: "Le Journal Secret des Étoiles",
            .historyHeaderSubtitle: "Chaque mot murmuré par l'univers est un joyau caché dans votre cœur.",
            .setupTitle:         "Cartographiez votre Destin",
            .setupSubtitle:      "Nos anciens utilisent ces détails pour aligner vos étoiles.",
            .setupFullName:      "Nom complet",
            .setupFullNamePlaceholder: "Ex. Alexander Orion",
            .setupBirthDate:     "Date de naissance",
            .setupBirthTime:     "Heure exacte de naissance",
            .setupPersonalityTest: "TEST DE PERSONNALITÉ",
            .setupQuestion:      "De quel élément vous sentez-vous le plus proche ?",
            .setupContinue:      "Continuer le voyage",
            .setupStep:          "Étape 1 sur 3 : Alignement spirituel",
            .setupNavTitle:      "Configuration de la carte du ciel",
            .quizTitle:          "Analyse de personnalité",
            .quizSubtitle:       "Aidez-nous à mieux vous connaître.",
            .quizYes:            "Oui",
            .quizNo:             "Non",
        ],

        // ──────────────────────────────────────────
        // MARK: Spanish
        // ──────────────────────────────────────────
        .spanish: [
            .tabHome:        "Inicio",
            .tabReading:     "Lectura",
            .tabScan:        "Escanear",
            .tabHistory:     "Historial",
            .tabSettings:    "Ajustes",

            .homeTitle:       "Perfil Oráculo",
            .homeStrengths:   "Fortalezas",
            .homeWeaknesses:  "Debilidades",
            .homeDailyFortune:"VER FORTUNA DIARIA",
            .homePersonality: "VER ANÁLISIS DE PERSONALIDAD",
            .homeTier:        "MÍSTICO NIVEL IV",
            .homeGreetingsMorning: "BUENOS DÍAS",
            .homeGreetingsAfternoon: "BUENAS TARDES",
            .homeGreetingsEvening: "BUENAS NOCHES",
            .homeGreetingsNight: "BUENAS NOCHES",
            .homeMysticMorning: "Con el amanecer, las puertas del universo se abren, tu alma encuentra la luz.",
            .homeMysticAfternoon: "En el momento más brillante del día, la sabiduría antigua comienza a fluir en tu mente.",
            .homeMysticEvening: "A medida que las estrellas se asientan en el cielo, mensajes misteriosos llegan a tu intuición.",
            .homeMysticNight: "En las profundidades de la noche, las estrellas brillan, susurrando mensajes que te guían.",

            .scanTitle:       "Escanea tu ojo",
            .scanSubtitle:    "La IA leerá tu destino a través de tu iris.",
            .scanButton:      "Iniciar escaneo",
            .scanning:        "Escaneando...",
            .scanAnalyzing:   "Analizando...",

            .fortuneTitle:    "Lectura de IA",
            .fortuneSaveClose:"Guardar y cerrar",
            .fortuneClose:    "Cerrar",

            .historyTitle:    "Historial de fortunas",
            .historyEmpty:    "Aún no hay fortunas guardadas.",

            .settingsTitle:           "Configuración mística",
            .settingsSectionGeneral:  "EXPERIENCIA GENERAL",
            .settingsSectionSupport:  "SOPORTE & LEGAL",
            .settingsSectionAccount:  "CUENTA Y DATOS",
            .settingsLogout:          "Cerrar sesión",
            .settingsDeleteAccount:   "Eliminar cuenta",
            .settingsNotifications:   "Configuración de notificaciones",
            .settingsNotifSub:        "Lecturas diarias y alertas cósmicas",
            .settingsPrivacy:         "Privacidad de la cuenta",
            .settingsPrivacySub:      "Controla tus datos espirituales",
            .settingsTheme:           "Selección de tema",
            .settingsThemeSub:        "Personaliza tu interfaz",
            .settingsLanguage:        "Idioma",
            .settingsLanguageSub:     "Cambiar el idioma de la app",
            .settingsSubscription:    "Suscripción",
            .settingsSubscriptionSub: "Gestiona tu plan premium",
            .settingsHelp:            "Centro de ayuda",
            .settingsHelpSub:         "Los oráculos están aquí para ayudarte",
            .settingsDeleteProfile:   "Eliminar perfil cósmico",
            .settingsVersion:         "VERSIÓN 2.4.0 (ESTELAR)",
            .settingsSelectLanguage:  "Seleccionar idioma",

            .premiumTitle:    "Premium Celestial",
            .premiumSubtitle: "Desbloquea horóscopos detallados y alineaciones planetarias.",
            .premiumUpgrade:  "Mejorar ahora",

            .loginTitle:              "Desbloquea tu destino",
            .loginSubtitle:           "Las estrellas han escrito tu historia. Inicia sesión para leerla.",
            .loginEmail:              "Correo electrónico",
            .loginEmailPlaceholder:   "Ingresa tu correo celestial",
            .loginPassword:           "Contraseña",
            .loginPasswordPlaceholder:"Ingresa tu clave secreta",
            .loginForgot:             "¿Olvidaste tu contraseña?",
            .loginButton:             "Consultar al oráculo",
            .loginOrConnect:          "O CONECTAR VÍA",
            .loginGoogle:             "Continuar con Google",
            .loginInstagram:          "Continuar con Instagram",
            .loginApple:              "Continuar con Apple",
            .loginNewUser:            "¿Nuevo en el cosmos?",
            .loginRegister:           "Regístrate ahora",

            .readingTitle:    "Lectura diaria",
            .readingFeatured: "Destacado",
            .readingFeaturedSub: "Hoy",
            .readingBegin:    "Comenzar lectura",
            .readingMinutes:  "min de lectura",
            .readingCatAll:   "Todo",
            .readingCatMed:   "Meditación",
            .readingCatPers:  "Personalidad",
            .readingCatDev:   "Desarrollo",
            .readingCatMind:  "Mindfulness",
            .readingCatWell:  "Bienestar",
            .readingEmpty:    "No hay contenido en esta categoría hoy",
            .readingToday:    "Hoy",
            .historyHeaderTitle: "El Diario Secreto de las Estrellas",
            .historyHeaderSubtitle: "Cada palabra susurrada por el universo es una joya escondida en tu corazón.",
            .setupTitle:         "Mapea tu Destino",
            .setupSubtitle:      "Nuestros ancianos usan estos detalles para alinear tus estrellas.",
            .setupFullName:      "Nombre completo",
            .setupFullNamePlaceholder: "Ej. Alexander Orion",
            .setupBirthDate:     "Fecha de nacimiento",
            .setupBirthTime:     "Hora exacta de nacimiento",
            .setupPersonalityTest: "TEST DE PERSONALIDAD",
            .setupQuestion:      "¿Con qué elemento te sientes más conectado?",
            .setupContinue:      "Continuar viaje",
            .setupStep:          "Paso 1 de 3: Alineación espiritual",
            .setupNavTitle:      "Configuración de la carta natal",
            .quizTitle:          "Análisis de personalidad",
            .quizSubtitle:       "Ayúdanos a conocerte mejor.",
            .quizYes:            "Sí",
            .quizNo:             "No",
        ],

        // ──────────────────────────────────────────
        // MARK: German
        // ──────────────────────────────────────────
        .german: [
            .tabHome:        "Startseite",
            .tabReading:     "Lesen",
            .tabScan:        "Auge scannen",
            .tabHistory:     "Verlauf",
            .tabSettings:    "Einstellungen",

            .homeTitle:       "Orakel-Profil",
            .homeStrengths:   "Stärken",
            .homeWeaknesses:  "Schwächen",
            .homeDailyFortune:"TAGESHOROSKOP ANZEIGEN",
            .homePersonality: "PERSÖNLICHKEITSANALYSE ANZEIGEN",
            .homeTier:        "MYSTIKER STUFE IV",
            .homeGreetingsMorning: "GUTEN MORGEN",
            .homeGreetingsAfternoon: "GUTEN TAG",
            .homeGreetingsEvening: "GUTEN ABEND",
            .homeGreetingsNight: "GUTE NACHT",
            .homeMysticMorning: "Mit dem Sonnenaufgang öffnen sich die Tore des Universums, deine Seele findet Licht.",
            .homeMysticAfternoon: "Im hellsten Moment des Tages beginnt alte Weisheit in deinen Geist zu fließen.",
            .homeMysticEvening: "Während sich die Sterne am Himmel niederlassen, erreichen geheimnisvolle Botschaften deine Intuition.",
            .homeMysticNight: "In den Tiefen der Nacht leuchten die Sterne und flüstern Botschaften, die dich leiten.",

            .scanTitle:       "Auge scannen",
            .scanSubtitle:    "Die KI liest dein Schicksal in deiner Iris.",
            .scanButton:      "Scan starten",
            .scanning:        "Scannen...",
            .scanAnalyzing:   "Analysieren...",

            .fortuneTitle:    "KI-Lesung",
            .fortuneSaveClose:"Speichern & Schließen",
            .fortuneClose:    "Schließen",

            .historyTitle:    "Horoskop-Verlauf",
            .historyEmpty:    "Noch keine Horoskope gespeichert.",

            .settingsTitle:           "Mystische Einstellungen",
            .settingsSectionGeneral:  "ALLGEMEINE ERFAHRUNG",
            .settingsSectionSupport:  "SUPPORT & RECHT",
            .settingsSectionAccount:  "KONTO UND DATEN",
            .settingsLogout:          "Abmelden",
            .settingsDeleteAccount:   "Konto löschen",
            .settingsNotifications:   "Benachrichtigungseinstellungen",
            .settingsNotifSub:        "Tägliche Lesungen & kosmische Alarme",
            .settingsPrivacy:         "Kontodatenschutz",
            .settingsPrivacySub:      "Kontrolliere deine spirituellen Daten",
            .settingsTheme:           "Theme-Auswahl",
            .settingsThemeSub:        "Passe dein Interface an",
            .settingsLanguage:        "Sprache",
            .settingsLanguageSub:     "App-Sprache ändern",
            .settingsSubscription:    "Abonnement",
            .settingsSubscriptionSub: "Verwalte deinen Premium-Plan",
            .settingsHelp:            "Hilfecenter",
            .settingsHelpSub:         "Orakel helfen dir gerne",
            .settingsDeleteProfile:   "Kosmisches Profil löschen",
            .settingsVersion:         "APP-VERSION 2.4.0 (STELLAR)",
            .settingsSelectLanguage:  "Sprache auswählen",

            .premiumTitle:    "Celestial Premium",
            .premiumSubtitle: "Schalte detaillierte Horoskope und Planetenausrichtungen frei.",
            .premiumUpgrade:  "Jetzt upgraden",

            .loginTitle:              "Enthülle dein Schicksal",
            .loginSubtitle:           "Die Sterne haben deine Geschichte geschrieben. Melde dich an.",
            .loginEmail:              "E-Mail-Adresse",
            .loginEmailPlaceholder:   "Gib deine kosmische E-Mail ein",
            .loginPassword:           "Passwort",
            .loginPasswordPlaceholder:"Gib deinen geheimen Schlüssel ein",
            .loginForgot:             "Passwort vergessen?",
            .loginButton:             "Das Orakel befragen",
            .loginOrConnect:          "ODER VERBINDEN MIT",
            .loginGoogle:             "Mit Google fortfahren",
            .loginInstagram:          "Mit Instagram fortfahren",
            .loginApple:              "Mit Apple fortfahren",
            .loginNewUser:            "Neu im Kosmos?",
            .loginRegister:           "Jetzt registrieren",

            .readingTitle:    "Tägliche Lektüre",
            .readingFeatured: "Empfohlen",
            .readingFeaturedSub: "Heute",
            .readingBegin:    "Lesen beginnen",
            .readingMinutes:  "Min. Lesen",
            .readingCatAll:   "Alle",
            .readingCatMed:   "Meditation",
            .readingCatPers:  "Persönlichkeit",
            .readingCatDev:   "Entwicklung",
            .readingCatMind:  "Achtsamkeit",
            .readingCatWell:  "Wohlbefinden",
            .readingEmpty:    "Kein Inhalt in dieser Kategorie heute",
            .readingToday:    "Heute",
            .historyHeaderTitle: "Das geheime Tagebuch der Sterne",
            .historyHeaderSubtitle: "Jedes vom Universum geflüsterte Wort ist ein in deinem Herzen verborgenes Juwel.",
            .setupTitle:         "Plane dein Schicksal",
            .setupSubtitle:      "Unsere Ältesten nutzen diese Details, um deine Sterne auszurichten.",
            .setupFullName:      "Vollständiger Name",
            .setupFullNamePlaceholder: "Z.B. Alexander Orion",
            .setupBirthDate:     "Geburtsdatum",
            .setupBirthTime:     "Genaue Geburtszeit",
            .setupPersonalityTest: "PERSÖNLICHKEITSTEST",
            .setupQuestion:      "Mit welchem Element fühlst du dich am meisten verbunden?",
            .setupContinue:      "Reise fortsetzen",
            .setupStep:          "Schritt 1 von 3: Spirituelle Ausrichtung",
            .setupNavTitle:      "Erstellung des Geburtshoroskops",
            .quizTitle:          "Persönlichkeitsanalyse",
            .quizSubtitle:       "Hilf uns, dich besser kennenzulernen.",
            .quizYes:            "Ja",
            .quizNo:             "Nein",
        ],

        // ──────────────────────────────────────────
        // MARK: Italian
        // ──────────────────────────────────────────
        .italian: [
            .tabHome:        "Home",
            .tabReading:     "Lettura",
            .tabScan:        "Scansiona",
            .tabHistory:     "Cronologia",
            .tabSettings:    "Impostazioni",

            .homeTitle:       "Profilo Oracolo",
            .homeStrengths:   "Punti di forza",
            .homeWeaknesses:  "Punti deboli",
            .homeDailyFortune:"VEDI FORTUNA GIORNALIERA",
            .homePersonality: "VEDI ANALISI DELLA PERSONALITÀ",
            .homeTier:        "MISTICO LIVELLO IV",
            .homeGreetingsMorning: "BUONGIORNO",
            .homeGreetingsAfternoon: "BUON POMERIGGIO",
            .homeGreetingsEvening: "BUONASERA",
            .homeGreetingsNight: "BUONANOTTE",
            .homeMysticMorning: "Con l'alba, le porte dell'universo si aprono, la tua anima trova la luce.",
            .homeMysticAfternoon: "Nel momento più luminoso della giornata, l'antica saggezza inizia a scorrere nella tua mente.",
            .homeMysticEvening: "Mentre le stelle si sistemano nel cielo, messaggi misteriosi raggiungono il tuo intuito.",
            .homeMysticNight: "Nelle profondità della notte, le stelle brillano, sussurrando messaggi che ti guidano.",

            .scanTitle:       "Scansiona il tuo occhio",
            .scanSubtitle:    "L'IA leggerà il tuo destino nel tuo iride.",
            .scanButton:      "Avvia scansione",
            .scanning:        "Scansione in corso...",
            .scanAnalyzing:   "Analisi in corso...",

            .fortuneTitle:    "Lettura IA",
            .fortuneSaveClose:"Salva e chiudi",
            .fortuneClose:    "Chiudi",

            .historyTitle:    "Storico fortune",
            .historyEmpty:    "Nessuna fortuna salvata ancora.",

            .settingsTitle:           "Impostazioni mistiche",
            .settingsSectionGeneral:  "ESPERIENZA GENERALE",
            .settingsSectionSupport:  "SUPPORTO & LEGALE",
            .settingsSectionAccount:  "ACCOUNT E DATI",
            .settingsLogout:          "Esci",
            .settingsDeleteAccount:   "Elimina account",
            .settingsNotifications:   "Impostazioni notifiche",
            .settingsNotifSub:        "Letture giornaliere e avvisi cosmici",
            .settingsPrivacy:         "Privacy dell'account",
            .settingsPrivacySub:      "Controlla i tuoi dati spirituali",
            .settingsTheme:           "Selezione tema",
            .settingsThemeSub:        "Personalizza la tua interfaccia",
            .settingsLanguage:        "Lingua",
            .settingsLanguageSub:     "Cambia la lingua dell'app",
            .settingsSubscription:    "Abbonamento",
            .settingsSubscriptionSub: "Gestisci il tuo piano premium",
            .settingsHelp:            "Centro assistenza",
            .settingsHelpSub:         "Gli oracoli sono qui per aiutarti",
            .settingsDeleteProfile:   "Elimina profilo cosmico",
            .settingsVersion:         "VERSIONE APP 2.4.0 (STELLARE)",
            .settingsSelectLanguage:  "Seleziona lingua",

            .premiumTitle:    "Premium Celestiale",
            .premiumSubtitle: "Sblocca oroscopi dettagliati e allineamenti planetari.",
            .premiumUpgrade:  "Aggiorna ora",

            .loginTitle:              "Svela il tuo destino",
            .loginSubtitle:           "Le stelle hanno scritto la tua storia. Accedi per leggerla.",
            .loginEmail:              "Indirizzo e-mail",
            .loginEmailPlaceholder:   "Inserisci la tua e-mail celestiale",
            .loginPassword:           "Password",
            .loginPasswordPlaceholder:"Inserisci la tua chiave segreta",
            .loginForgot:             "Password dimenticata?",
            .loginButton:             "Consulta l'oracolo",
            .loginOrConnect:          "O CONNETTITI TRAMITE",
            .loginGoogle:             "Continua con Google",
            .loginInstagram:          "Continua con Instagram",
            .loginApple:              "Continua con Apple",
            .loginNewUser:            "Nuovo nel cosmo?",
            .loginRegister:           "Registrati ora",

            .readingTitle:    "Lettura giornaliera",
            .readingFeatured: "In evidenza",
            .readingFeaturedSub: "Oggi",
            .readingBegin:    "Inizia la lettura",
            .readingMinutes:  "min di lettura",
            .readingCatAll:   "Tutti",
            .readingCatMed:   "Meditazione",
            .readingCatPers:  "Personalità",
            .readingCatDev:   "Sviluppo",
            .readingCatMind:  "Mindfulness",
            .readingCatWell:  "Benessere",
            .readingEmpty:    "Nessun contenuto in questa categoria oggi",
            .readingToday:    "Oggi",
            .historyHeaderTitle: "Il Diario Segreto delle Stelle",
            .historyHeaderSubtitle: "Ogni parola sussurrata dall'universo è un gioiello nascosto nel tuo cuore.",
            .setupTitle:         "Mappa il tuo Destino",
            .setupSubtitle:      "I nostri anziani usano questi dettagli per allineare le tue stelle.",
            .setupFullName:      "Nome completo",
            .setupFullNamePlaceholder: "Es. Alexander Orion",
            .setupBirthDate:     "Data di nascita",
            .setupBirthTime:     "Ora esatta di nascita",
            .setupPersonalityTest: "TEST DI PERSONALITÀ",
            .setupQuestion:      "A quale elemento ti senti più legato?",
            .setupContinue:      "Continua il viaggio",
            .setupStep:          "Passaggio 1 di 3: Allineamento spirituale",
            .setupNavTitle:      "Configurazione del tema natale",
            .quizTitle:          "Analisi della personalità",
            .quizSubtitle:       "Aiutaci a conoscerti meglio.",
            .quizYes:            "Sì",
            .quizNo:             "No",
        ],
    ]
}
