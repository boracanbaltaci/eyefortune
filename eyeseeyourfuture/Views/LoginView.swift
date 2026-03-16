import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    
    // State variables
    @State private var email = ""
    @State private var password = ""
    @State private var showSubscription = false
    @State private var showPersonalSetup = false
    @State private var navigateToRegister = false
    @State private var showError = false
    
    @AppStorage("userEmail") var userEmail: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            Spacer(minLength: 40)
                            
                            // Centered Container
                            VStack(spacing: 40) {
                                // Centered Title
                                VStack(spacing: 12) {
                                    Text("Giriş Yap")
                                        .font(.system(size: 36, weight: .bold, design: .serif))
                                        .foregroundColor(themeManager.primaryTextColor)
                                    
                                    Text("Kozmik yolculuğuna kaldığın yerden devam et.")
                                        .font(.system(size: 16))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                }
                                
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
                                    
                                    // Consult the Oracle Button
                                    Button(action: {
                                        authManager.loginWithEmail(email: email, password: password) { success in
                                            if success {
                                                userEmail = email
                                                showSubscription = true
                                            } else {
                                                showError = true
                                            }
                                        }
                                    }) {
                                        HStack {
                                            if authManager.isLoading {
                                                ProgressView()
                                                    .tint(themeManager.bgColor)
                                            } else {
                                                Text("Giriş Yap")
                                                    .font(.system(size: 17, weight: .bold))
                                                Image(systemName: "sparkles")
                                            }
                                        }
                                        .foregroundColor(themeManager.bgColor)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(themeManager.accentYellow)
                                        .cornerRadius(30)
                                        .shadow(color: themeManager.accentYellow.opacity(0.4), radius: 10, x: 0, y: 0)
                                    }
                                    .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
                                    .padding(.top, 10)
                                }
                                .padding(.horizontal, 20)
                                .alert("Hata", isPresented: $showError) {
                                    Button("Tamam", role: .cancel) { }
                                } message: {
                                    Text(authManager.errorMessage ?? "Giriş yapılamadı. Lütfen bilgilerinizi kontrol edin.")
                                }
                                
                                // Divider
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
                                
                                // Login Social Buttons
                                VStack(spacing: 15) {
                                    LoginSocialButton(title: lm.t(.loginGoogle), iconName: "google", themeManager: themeManager) {
                                        authManager.loginWithGoogle { success in
                                            if success {
                                                showSubscription = true
                                            } else {
                                                showError = true
                                            }
                                        }
                                    }
                                    
                                    // Custom Styled Sign in with Apple Button
                                    SignInWithAppleButton(.signIn) { request in
                                        authManager.prepareAppleSignInRequest(request)
                                    } onCompletion: { result in
                                        authManager.handleAppleSignInCompletion(result) { success in
                                            if success {
                                                showSubscription = true
                                            } else {
                                                showError = true
                                            }
                                        }
                                    }
                                    .signInWithAppleButtonStyle(themeManager.activeTheme == .midnight ? .white : .black)
                                    .frame(height: 50)
                                    .cornerRadius(25)
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            Spacer(minLength: 30)
                            
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
                            .padding(.bottom, 30)
                        }
                        .frame(minHeight: geometry.size.height)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                if authManager.user != nil && !isSetupComplete {
                    showSubscription = true
                }
            }
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
    @EnvironmentObject var authManager: AuthManager
    @ObservedObject var themeManager: ThemeManager
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if iconName == "google" {
                    Image(systemName: "g.circle.fill")
                        .foregroundColor(themeManager.accentYellow)
                        .font(.system(size: 20))
                } else {
                    Image(systemName: iconName)
                        .foregroundColor(themeManager.accentYellow)
                        .font(.system(size: 16))
                }
                
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
