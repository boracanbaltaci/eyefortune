import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Premium Banner
                        PremiumBanner(themeManager: themeManager)
                        
                        // General Experience Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("GENERAL EXPERIENCE")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(themeManager.accentYellow.opacity(0.7))
                                .padding(.leading, 16)
                            
                            VStack(spacing: 8) {
                                SettingsRow(
                                    icon: "bell.badge.fill",
                                    title: "Notification Settings",
                                    subtitle: "Daily readings & cosmic alerts",
                                    themeManager: themeManager
                                )
                                
                                SettingsRow(
                                    icon: "eye.slash.fill",
                                    title: "Account Privacy",
                                    subtitle: "Control your spiritual data",
                                    themeManager: themeManager
                                )
                                
                                ThemeToggleRow(themeManager: themeManager)
                            }
                        }
                        
                        // Support & Legal Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SUPPORT & LEGAL")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(themeManager.accentYellow.opacity(0.7))
                                .padding(.leading, 16)
                            
                            VStack(spacing: 8) {
                                SettingsRow(
                                    icon: "sparkles.rectangle.stack.fill",
                                    title: "Subscription",
                                    subtitle: "Manage your premium plan",
                                    themeManager: themeManager
                                )
                                
                                SettingsRow(
                                    icon: "questionmark.circle.fill",
                                    title: "Help Center",
                                    subtitle: "Oracles are here to help",
                                    showExternalIcon: true,
                                    themeManager: themeManager
                                )
                            }
                        }
                        
                        // Delete Profile
                        VStack(spacing: 16) {
                            Button(action: {
                                // Delete Action
                            }) {
                                Text("Delete Cosmic Profile")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.red)
                            }
                            .padding(.top, 16)
                            
                            Text("APP VERSION 2.4.0 (STELLAR)")
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
                    Text("Mystic Settings")
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
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
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Celestial Premium")
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .foregroundColor(themeManager.accentYellow)
                
                Text("Unlock daily detailed horoscopes and planetary alignments.")
                    .font(.system(size: 13))
                    .foregroundColor(themeManager.primaryTextColor.opacity(0.8))
                    .padding(.bottom, 8)
                
                Button(action: {}) {
                    Text("Upgrade Now")
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
            
            // Background Icon
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
                Text("Theme Selection")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(themeManager.primaryTextColor)
                
                Text("Customize your interface vibes")
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
}
