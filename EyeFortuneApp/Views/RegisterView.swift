import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    // State variables for form fields
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
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
                            Text("Begin Your Journey")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                                .foregroundColor(themeManager.primaryTextColor)
                            
                            Text("Enter your details to reveal what the stars have\nin store for you.")
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
                                title: "Full Name",
                                placeholder: "Enter your name",
                                iconName: "person.fill",
                                text: $fullName,
                                isSecure: false,
                                themeManager: themeManager
                            )
                            
                            CustomTextField(
                                title: "Email",
                                placeholder: "your.soul@cosmos.com",
                                iconName: "envelope.fill",
                                text: $email,
                                isSecure: false,
                                themeManager: themeManager
                            )
                            
                            CustomTextField(
                                title: "Password",
                                placeholder: "••••••••",
                                iconName: "lock.fill",
                                text: $password,
                                isSecure: true,
                                themeManager: themeManager
                            )
                            
                            CustomTextField(
                                title: "Confirm Password",
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
                            // Action here
                        }) {
                            HStack {
                                Text("Create Account")
                                    .font(.system(size: 17, weight: .bold))
                                Image(systemName: "sparkles")
                            }
                            .foregroundColor(themeManager.bgColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(themeManager.accentYellow)
                            .cornerRadius(30)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                        // Social Buttons removed as requested

                        
                        // Login Link
                        HStack(spacing: 5) {
                            Text("Already have an account?")
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.secondaryTextColor)
                            Button(action: {
                                // Action to login view or dismiss
                            }) {
                                Text("Log In")
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(themeManager.accentYellow)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Celestial Guidance")
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                }
            }
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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
