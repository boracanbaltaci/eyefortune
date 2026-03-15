import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    @Environment(\.presentationMode) var presentationMode

    @State private var showLanguagePicker = false
    @State private var showSubscription = false
    @AppStorage("notificationsEnabled") var notificationsEnabled = true
    @AppStorage("isPremium") var isPremium = false
    @State private var showHelpCenter = false
    @State private var showDeleteConfirmation = false
    @State private var showInfoPopup = false
    @State private var navigateToInfoDetail = false
    @State private var showContactUs = false

    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 24) {

                        PremiumBanner(themeManager: themeManager, lm: lm) {
                            showSubscription = true
                        }

                        // Account Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("HESAP VE VERİ")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(themeManager.accentYellow.opacity(0.7))
                                .padding(.leading, 16)

                            VStack(spacing: 8) {
                                NavigationLink(destination: PersonalInformationDetailView()) {
                                    SettingsRow(
                                        icon: "person.text.rectangle.fill",
                                        title: "Kişisel Bilgiler",
                                        subtitle: "Ad, doğum tarihi ve kişilik verileri",
                                        themeManager: themeManager
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: { showContactUs = true }) {
                                    SettingsRow(
                                        icon: "eye.fill",
                                        title: "Göz Rengimi Düzelt",
                                        subtitle: "Yanlış belirlendiyse talep oluşturun",
                                        themeManager: themeManager
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }

                        // General Experience Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(lm.t(.settingsSectionGeneral))
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(themeManager.accentYellow.opacity(0.7))
                                .padding(.leading, 16)

                            VStack(spacing: 8) {
                                NotificationToggleRow(
                                    isEnabled: $notificationsEnabled,
                                    themeManager: themeManager,
                                    lm: lm
                                )

                                ThemeToggleRow(themeManager: themeManager, lm: lm)

                                // Language Picker Row
                                LanguagePickerRow(
                                    themeManager: themeManager,
                                    lm: lm,
                                    showPicker: $showLanguagePicker
                                )
                            }
                        }

                        // Support & Legal Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(lm.t(.settingsSectionSupport))
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(themeManager.accentYellow.opacity(0.7))
                                .padding(.leading, 16)

                            VStack(spacing: 8) {
                                Button(action: { showSubscription = true }) {
                                    SettingsRow(
                                        icon: "sparkles.rectangle.stack.fill",
                                        title: lm.t(.settingsSubscription),
                                        subtitle: lm.t(.settingsSubscriptionSub),
                                        themeManager: themeManager
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())

                                Button(action: { showHelpCenter = true }) {
                                    SettingsRow(
                                        icon: "questionmark.circle.fill",
                                        title: lm.t(.settingsHelp),
                                        subtitle: lm.t(.settingsHelpSub),
                                        showExternalIcon: false,
                                        themeManager: themeManager
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())

                                Button(action: { 
                                    if let url = URL(string: "https://example.com/privacy") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    SettingsRow(
                                        icon: "shield.lefthalf.filled",
                                        title: "Gizlilik Politikası",
                                        subtitle: "Verilerinizin nasıl korunduğunu görün",
                                        showExternalIcon: true,
                                        themeManager: themeManager
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())

                                Button(action: {
                                    // Rate us link
                                }) {
                                    SettingsRow(
                                        icon: "star.bubble.fill",
                                        title: "Bizi Değerlendir",
                                        subtitle: "App Store'da yorum bırakın",
                                        showExternalIcon: true,
                                        themeManager: themeManager
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }

                        // Developer Test Section (Temporary)
                        VStack(alignment: .leading, spacing: 12) {
                            Text(lm.t(.settingsDevSection))
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(.red.opacity(0.7))
                                .padding(.leading, 16)
                            
                            VStack(spacing: 8) {
                                Button(action: {
                                    NotificationManager.shared.triggerTestNotifications()
                                }) {
                                    HStack {
                                        Image(systemName: "bell.badge.fill")
                                        Text(lm.t(.settingsTestNotif))
                                        Spacer()
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 12))
                                    }
                                    .padding()
                                    .background(themeManager.cardBgColor)
                                    .cornerRadius(12)
                                    .foregroundColor(themeManager.primaryTextColor)
                                }
                                
                                NavigationLink(destination: WidgetThemeTestView(themeManager: themeManager, lm: lm)) {
                                    HStack {
                                        Image(systemName: "square.grid.2x2.fill")
                                        Text(lm.t(.settingsTestWidget))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                    }
                                    .padding()
                                    .background(themeManager.cardBgColor)
                                    .cornerRadius(12)
                                    .foregroundColor(themeManager.primaryTextColor)
                                }
                                
                                HStack {
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(themeManager.accentYellow)
                                    Text("Premium Status")
                                    Spacer()
                                    Toggle("", isOn: $isPremium)
                                        .labelsHidden()
                                        .tint(themeManager.accentYellow)
                                }
                                .padding()
                                .background(themeManager.cardBgColor)
                                .cornerRadius(12)
                                .foregroundColor(themeManager.primaryTextColor)
                            }
                        }

                        // Delete Profile
                        VStack(spacing: 16) {
                            Button(action: {
                                showDeleteConfirmation = true
                            }) {
                                Text("Hesabı Sil")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.red)
                            }
                            .padding(.top, 16)

                            Text(lm.t(.settingsVersion))
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(themeManager.secondaryTextColor.opacity(0.4))
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(themeManager.primaryTextColor)
                            .font(.system(size: 18))
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text(lm.t(.settingsTitle))
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerSheet(themeManager: themeManager, lm: lm)
            }
            .sheet(isPresented: $showSubscription) {
                SubscriptionView(shouldShowPersonalSetup: .constant(false))
            }
            .sheet(isPresented: $showHelpCenter) {
                HelpCenterView()
            }
            .sheet(isPresented: $showContactUs) {
                ContactUsView()
            }

            .alert("Hesabı Sil", isPresented: $showDeleteConfirmation) {
                Button("Vazgeç", role: .cancel) { }
                Button("Sil", role: .destructive) {
                    deleteProfile()
                }
            } message: {
                Text("Profilinizi silmek istediğinize emin misiniz? Tüm verileriniz kalıcı olarak silinecektir.")
            }
        }
    }

    private func deleteProfile() {
        // Clear all relevant @AppStorage keys
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userZodiac")
        UserDefaults.standard.removeObject(forKey: "userGender")
        UserDefaults.standard.removeObject(forKey: "userBirthDate")
        UserDefaults.standard.removeObject(forKey: "isSetupComplete")
        UserDefaults.standard.removeObject(forKey: "onboardingStep")
        
        // This will trigger the app to return to LoginView
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Notification Toggle Row
struct NotificationToggleRow: View {
    @Binding var isEnabled: Bool
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.accentYellow.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: "bell.badge.fill")
                    .foregroundColor(themeManager.accentYellow)
                    .font(.system(size: 18))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(lm.t(.settingsNotifications))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(themeManager.primaryTextColor)

                Text(lm.t(.settingsNotifSub))
                    .font(.system(size: 11))
                    .foregroundColor(themeManager.secondaryTextColor)
            }

            Spacer()

            Toggle("", isOn: $isEnabled)
                .labelsHidden()
                .tint(themeManager.accentYellow)
        }
        .padding(16)
        .background(themeManager.cardBgColor)
        .cornerRadius(12)
    }
}

// MARK: - Language Picker Row
struct LanguagePickerRow: View {
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager
    @Binding var showPicker: Bool

    var body: some View {
        Button(action: { showPicker = true }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(themeManager.accentYellow.opacity(0.2))
                        .frame(width: 40, height: 40)
                    Text(lm.language.flag)
                        .font(.system(size: 22))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(lm.t(.settingsLanguage))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(themeManager.primaryTextColor)
                    Text(lm.t(.settingsLanguageSub))
                        .font(.system(size: 12))
                        .foregroundColor(themeManager.secondaryTextColor)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text(lm.language.displayName)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(themeManager.accentYellow)
                    Image(systemName: "chevron.right")
                        .foregroundColor(themeManager.accentYellow.opacity(0.4))
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .padding(16)
            .background(themeManager.cardBgColor)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Language Picker Sheet
struct LanguagePickerSheet: View {
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(AppLanguage.allCases) { language in
                            Button(action: {
                                withAnimation {
                                    lm.language = language
                                }
                                dismiss()
                            }) {
                                HStack(spacing: 16) {
                                    Text(language.flag)
                                        .font(.system(size: 28))

                                    Text(language.displayName)
                                        .font(.system(size: 17, weight: .medium, design: .serif))
                                        .foregroundColor(themeManager.primaryTextColor)

                                    Spacer()

                                    if lm.language == language {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(themeManager.accentYellow)
                                            .font(.system(size: 20))
                                    }
                                }
                                .padding(16)
                                .background(
                                    lm.language == language
                                        ? themeManager.accentYellow.opacity(0.1)
                                        : themeManager.cardBgColor
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(
                                            lm.language == language
                                                ? themeManager.accentYellow.opacity(0.4)
                                                : themeManager.accentYellow.opacity(0.08),
                                            lineWidth: lm.language == language ? 1.5 : 1
                                        )
                                )
                                .cornerRadius(14)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(lm.t(.settingsSelectLanguage))
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(themeManager.secondaryTextColor)
                            .font(.system(size: 20))
                    }
                }
            }
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

// MARK: - Subcomponents
struct PremiumBanner: View {
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager
    let onUpgrade: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                Text(lm.t(.premiumTitle))
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .foregroundColor(themeManager.accentYellow)

                Text(lm.t(.premiumSubtitle))
                    .font(.system(size: 13))
                    .foregroundColor(themeManager.primaryTextColor.opacity(0.8))
                    .padding(.bottom, 8)

                Button(action: onUpgrade) {
                    Text(lm.t(.premiumUpgrade))
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(themeManager.bgColor)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(themeManager.accentYellow)
                        .cornerRadius(20)
                        .shadow(color: themeManager.accentYellow.opacity(0.3), radius: 5, x: 0, y: 3)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [themeManager.accentYellow.opacity(0.2), Color.clear]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(16)

            Image(systemName: "rosette")
                .font(.system(size: 120))
                .foregroundColor(themeManager.accentYellow.opacity(0.1))
                .offset(x: 20, y: -20)
                .clipped()
        }
    }
}

struct SettingsRow: View {
    var icon: String
    var title: String
    var subtitle: String
    var showExternalIcon: Bool = false
    @ObservedObject var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.accentYellow.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .foregroundColor(themeManager.accentYellow)
                    .font(.system(size: 18))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(themeManager.primaryTextColor)

                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(themeManager.secondaryTextColor)
            }

            Spacer()

            Image(systemName: showExternalIcon ? "arrow.up.right" : "chevron.right")
                .foregroundColor(themeManager.accentYellow.opacity(0.4))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(16)
        .background(themeManager.cardBgColor)
        .cornerRadius(12)
    }
}

struct ThemeToggleRow: View {
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(themeManager.accentYellow.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: "paintpalette.fill")
                    .foregroundColor(themeManager.accentYellow)
                    .font(.system(size: 18))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(lm.t(.settingsTheme))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(themeManager.primaryTextColor)

                Text(lm.t(.settingsThemeSub))
                    .font(.system(size: 12))
                    .foregroundColor(themeManager.secondaryTextColor)
            }

            Spacer()

            Button(action: {
                withAnimation {
                    themeManager.activeTheme = themeManager.activeTheme == .midnight ? .aurora : .midnight
                }
            }) {
                HStack(spacing: 4) {
                    Text(themeManager.activeTheme.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(themeManager.accentYellow)

                    Image(systemName: "chevron.right")
                        .foregroundColor(themeManager.accentYellow.opacity(0.4))
                        .font(.system(size: 14, weight: .semibold))
                }
            }
        }
        .padding(16)
        .background(themeManager.cardBgColor)
        .cornerRadius(12)
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
