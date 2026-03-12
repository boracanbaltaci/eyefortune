import Foundation

// MARK: - Localization Key Enum
// One case per unique UI string across the entire app.
enum LKey: String {

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

    // MARK: Scanner
    case scanTitle          = "scan_title"
    case scanSubtitle       = "scan_subtitle"
    case scanButton         = "scan_button"
    case scanning           = "scanning"
    case scanAnalyzing      = "scan_analyzing"

    // MARK: Fortune Result
    case fortuneTitle       = "fortune_title"
    case fortuneSaveClose   = "fortune_save_close"
    case fortuneClose       = "fortune_close"

    // MARK: History
    case historyTitle       = "history_title"
    case historyEmpty       = "history_empty"

    // MARK: Settings
    case settingsTitle          = "settings_title"
    case settingsSectionGeneral = "settings_section_general"
    case settingsSectionSupport = "settings_section_support"
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

            .scanTitle:       "Gözünü Tarat",
            .scanSubtitle:    "Yapay zeka göz irisine bakarak kaderini okuyacak.",
            .scanButton:      "Taramayı Başlat",
            .scanning:        "Taranıyor...",
            .scanAnalyzing:   "Analiz ediliyor...",

            .fortuneTitle:    "Yapay Zeka Okuması",
            .fortuneSaveClose:"Kaydet ve Kapat",
            .fortuneClose:    "Kapat",

            .historyTitle:    "Beğenilenler",
            .historyEmpty:    "Henüz beğendiğiniz bir fal yok.",

            .settingsTitle:           "Mistik Ayarlar",
            .settingsSectionGeneral:  "GENEL DENEYİM",
            .settingsSectionSupport:  "DESTEK & YASAL",
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
            .loginForgot:             "Şifremi Unuttum?",
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
            .readingCatWell:  "Sağlık",
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

            .scanTitle:       "Scan Your Eye",
            .scanSubtitle:    "AI will read your destiny through your iris.",
            .scanButton:      "Start Scan",
            .scanning:        "Scanning...",
            .scanAnalyzing:   "Analyzing...",

            .fortuneTitle:    "AI Reading",
            .fortuneSaveClose:"Save & Close",
            .fortuneClose:    "Close",

            .historyTitle:    "Fortune History",
            .historyEmpty:    "No saved fortunes yet.",

            .settingsTitle:           "Mystic Settings",
            .settingsSectionGeneral:  "GENERAL EXPERIENCE",
            .settingsSectionSupport:  "SUPPORT & LEGAL",
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
            .loginForgot:             "Forgot Password?",
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
            .readingCatWell:  "Wellness",
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
        ],
    ]
}
