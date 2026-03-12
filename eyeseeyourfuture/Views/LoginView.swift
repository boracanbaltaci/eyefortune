import SwiftUI

struct LoginView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    
    // State variables
    @State private var email = ""
    @State private var password = ""
    @State private var showSubscription = false
    @State private var showPersonalSetup = false
    @State private var navigateToRegister = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 0) {
                        
                        // Top Image Card with Text inside
                        ZStack {
                            // Border matching the design
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(themeManager.secondaryTextColor.opacity(0.1), lineWidth: 1)
                                .background(RoundedRectangle(cornerRadius: 20).fill(themeManager.cardBgColor))
                                
                            // Starry gradient for the "Unlock Your Destiny" card
                            ZStack {
                                LinearGradient(gradient: Gradient(colors: [themeManager.heroGradientTop, themeManager.heroGradientBottom]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                
                                ForEach(0..<15) { _ in
                                    Circle()
                                        .fill(Color.white.opacity(Double.random(in: 0.2...0.8)))
                                        .frame(width: CGFloat.random(in: 1...2), height: CGFloat.random(in: 1...2))
                                        .position(x: CGFloat.random(in: 0...300), y: CGFloat.random(in: 0...150))
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .opacity(0.8)
                            
                            VStack(spacing: 8) {
                                Text("Giriş Yap")
                                    .font(.system(size: 28, weight: .bold, design: .serif))
                                    .foregroundColor(themeManager.primaryTextColor)
                                    .multilineTextAlignment(.center)
                                
                                Text("Hikayeni öğren")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(themeManager.accentYellow)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 5)
                            }
                        }
                        .frame(height: 160)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            CustomTextField(
                                title: lm.t(.loginEmail),
                                placeholder: lm.t(.loginEmailPlaceholder),
                                iconName: "envelope.fill",
                                text: $email,
                                isSecure: false,
                                themeManager: themeManager
                            )
                            
                            VStack(alignment: .trailing, spacing: 6) {
                                HStack {
                                    Text(lm.t(.loginPassword))
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(themeManager.primaryTextColor)
                                    Spacer()
                                    Button(action: { /* Forgot Password action */ }) {
                                        Text(lm.t(.loginForgot))
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(themeManager.accentYellow)
                                    }
                                }
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(themeManager.accentYellow)
                                        .font(.system(size: 16))
                                        .frame(width: 20)
                                    
                                    SecureField(lm.t(.loginPasswordPlaceholder), text: $password)
                                        .foregroundColor(themeManager.accentYellow)
                                        .colorMultiply(password.isEmpty ? themeManager.accentYellow.opacity(0.6) : themeManager.primaryTextColor)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(themeManager.inputBgColor)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(themeManager.inputBgColor.opacity(0.5), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Consult the Oracle Button
                        Button(action: {
                            // Trigger subscription modal after login
                            showSubscription = true
                        }) {
                            HStack {
                                Text("Giriş Yap")
                                    .font(.system(size: 17, weight: .bold))
                                Image(systemName: "sparkles")
                            }
                            .foregroundColor(themeManager.bgColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(themeManager.accentYellow)
                            .cornerRadius(30)
                            // Adding a subtle glow effect to match design
                            .shadow(color: themeManager.accentYellow.opacity(0.4), radius: 10, x: 0, y: 0)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // OR CONNECT VIA Divider
                        HStack {
                            Rectangle()
                                .fill(themeManager.inputBgColor)
                                .frame(height: 1)
                            
                            Text("Veya")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(themeManager.secondaryTextColor)
                                .padding(.horizontal, 10)
                            
                            Rectangle()
                                .fill(themeManager.inputBgColor)
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        
                        // Login Social Buttons
                        VStack(spacing: 15) {
                            LoginSocialButton(title: lm.t(.loginGoogle), iconName: "envelope.fill", themeManager: themeManager)
                            LoginSocialButton(title: lm.t(.loginInstagram), iconName: "camera.fill", themeManager: themeManager)
                            LoginSocialButton(title: lm.t(.loginApple), iconName: "applelogo", themeManager: themeManager)
                        }
                        .padding(.horizontal, 20)
                        
                        // Register Link
                        HStack(spacing: 5) {
                            Text("Burada yeni misin?")
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.secondaryTextColor)
                            Button(action: {
                                navigateToRegister = true
                            }) {
                                Text(lm.t(.loginRegister))
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(themeManager.accentYellow)
                            }
                        }
                        .padding(.top, 25)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Giriş Yap")
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                }
            }
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .fullScreenCover(isPresented: $showSubscription) {
            SubscriptionView(shouldShowPersonalSetup: $showPersonalSetup)
        }
        .fullScreenCover(isPresented: $showPersonalSetup) {
            PersonalSetupView()
        }
    }
}

// MARK: - Reusable Full-width Social Button for Login
struct LoginSocialButton: View {
    var title: String
    var iconName: String
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(themeManager.accentYellow)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.primaryTextColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(themeManager.cardBgColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(themeManager.inputBgColor, lineWidth: 1.5)
            )
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
