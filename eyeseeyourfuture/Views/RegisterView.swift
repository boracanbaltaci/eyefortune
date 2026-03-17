import SwiftUI
import AuthenticationServices

struct RegisterView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    @Environment(\.presentationMode) var presentationMode
    
    // State variables for form fields
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var showSubscription = false
    @State private var showPersonalSetup = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Image Spacer
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [themeManager.heroGradientTop, themeManager.heroGradientBottom]), startPoint: .top, endPoint: .bottom)
                            
                            // Simulating some stars loosely
                            ForEach(0..<20) { _ in
                                Circle()
                                    .fill(Color.white.opacity(Double.random(in: 0.2...0.8)))
                                    .frame(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 1...3))
                                    .position(x: CGFloat.random(in: 0...400), y: CGFloat.random(in: 0...200))
                            }
                        }
                        .frame(height: 200)
                        // Slight gradient mask to blend into the background
                        .mask(LinearGradient(gradient: Gradient(stops: [
                            .init(color: .white, location: 0),
                            .init(color: .white, location: 0.8),
                            .init(color: .clear, location: 1)
                        ]), startPoint: .top, endPoint: .bottom))
                        .edgesIgnoringSafeArea(.top)
                        .padding(.top, -100)
                        
                        // Texts
                        VStack(spacing: 8) {
                            Text(lm.t(.registerTitle))
                                .font(.system(size: 28, weight: .bold, design: .serif))
                                .foregroundColor(themeManager.primaryTextColor)
                            
                            Text(lm.t(.registerSubtitle))
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(themeManager.secondaryTextColor)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                        
                        // Form Fields
                        VStack(spacing: 18) {
                            CustomTextField(
                                title: lm.t(.registerFullName),
                                placeholder: lm.t(.registerFullNamePlaceholder),
                                iconName: "person.fill",
                                text: $fullName,
                                isSecure: false,
                                themeManager: themeManager
                            )
                            
                            CustomTextField(
                                title: lm.t(.loginEmail),
                                placeholder: lm.t(.registerEmailPlaceholder),
                                iconName: "envelope.fill",
                                text: $email,
                                isSecure: false,
                                themeManager: themeManager
                            )
                            
                            CustomTextField(
                                title: lm.t(.loginPassword),
                                placeholder: "••••••••",
                                iconName: "lock.fill",
                                text: $password,
                                isSecure: true,
                                themeManager: themeManager
                            )
                            
                            CustomTextField(
                                title: lm.t(.loginPasswordPlaceholder), // Reusing password placeholder logic as confirm
                                placeholder: "••••••••",
                                iconName: "checkmark.shield.fill",
                                text: $confirmPassword,
                                isSecure: true,
                                themeManager: themeManager
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Create Account Button
                        Button(action: {
                            if fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                                authManager.errorMessage = "Tüm alanların doldurulması zorunludur."
                                showError = true
                            } else if password != confirmPassword {
                                authManager.errorMessage = lm.t(.registerPasswordMismatch)
                                showError = true
                            } else {
                                authManager.registerWithEmail(email: email, password: password, fullName: fullName) { success in
                                    if success {
                                        showSubscription = true
                                    } else {
                                        showError = true
                                    }
                                }
                            }
                        }) {
                            HStack {
                                if authManager.isLoading {
                                    ProgressView()
                                        .tint(themeManager.bgColor)
                                } else {
                                    Text(lm.t(.loginRegister))
                                        .font(.system(size: 17, weight: .bold))
                                    Image(systemName: "sparkles")
                                }
                            }
                            .foregroundColor(themeManager.bgColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(themeManager.accentYellow)
                            .cornerRadius(30)
                        }
                        .disabled(authManager.isLoading)
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .alert(lm.t(.alertError), isPresented: $showError) {
                            Button(lm.t(.alertOk), role: .cancel) { }
                        } message: {
                            Text(authManager.errorMessage ?? lm.t(.alertError))
                        }
                        
                        // MARK: Social Register
                        VStack(spacing: 25) {
                            HStack {
                                Rectangle()
                                    .fill(themeManager.inputBgColor)
                                    .frame(height: 1)
                                
                                Text(lm.t(.loginOrConnect))
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .padding(.horizontal, 10)
                                
                                Rectangle()
                                    .fill(themeManager.inputBgColor)
                                    .frame(height: 1)
                            }
                            
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
                                
                                SignInWithAppleButton(.signUp) { request in
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
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 25)
                        
                        // Login Link
                        HStack(spacing: 5) {
                            Text(lm.t(.registerAlreadyHaveAccount))
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.secondaryTextColor)
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text(lm.t(.loginEntry))
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(themeManager.accentYellow)
                            }
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(lm.t(.registerNavTitle))
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

// MARK: - Reusable Input Component
struct CustomTextField: View {
    var title: String
    var placeholder: String
    var iconName: String
    @Binding var text: String
    var isSecure: Bool
    
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(themeManager.primaryTextColor)
            
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(themeManager.accentYellow)
                    .font(.system(size: 18))
                    .frame(width: 20)
                
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .foregroundColor(themeManager.accentYellow)
                        // Hack to change placeholder color
                        .colorMultiply(text.isEmpty ? themeManager.accentYellow.opacity(0.6) : themeManager.primaryTextColor)
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundColor(themeManager.accentYellow)
                        .colorMultiply(text.isEmpty ? themeManager.accentYellow.opacity(0.6) : themeManager.primaryTextColor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(themeManager.inputBgColor)
            )
            // Giving the border a slight yellow tint outline matching the design loosely
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(themeManager.inputBgColor.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

// MARK: - Reusable Social Button without icons
struct SocialButtonRow: View {
    var name: String
    var inputBgColor: Color
    var accentYellow: Color
    
    var body: some View {
        Button(action: {}) {
            Text(name)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(accentYellow.opacity(0.8))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(inputBgColor, lineWidth: 2)
                )
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(ThemeManager())
}
