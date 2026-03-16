import SwiftUI

struct ContactUsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var message = ""
    @State private var showSuccessAlert = false
    
    @AppStorage("userName") var userNameStore: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "envelope.badge.shield.half.filled")
                                .font(.system(size: 48))
                                .foregroundColor(themeManager.accentYellow)
                                .padding(.bottom, 8)
                            
                            Text(lm.t(.contactTitle))
                                .font(.system(size: 28, weight: .bold, design: .serif))
                                .foregroundColor(themeManager.primaryTextColor)
                            
                            Text(lm.t(.contactSubtitle))
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.secondaryTextColor)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                        .padding(.top, 20)
                        
                        // Form
                        VStack(spacing: 20) {
                            ContactTextField(title: lm.t(.contactName), placeholder: lm.t(.registerFullNamePlaceholder), text: $fullName, themeManager: themeManager)
                            
                            ContactTextField(title: lm.t(.contactEmail), placeholder: "example@apple.com", text: $email, themeManager: themeManager, keyboardType: .emailAddress)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(lm.t(.contactMessage))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .padding(.leading, 4)
                                
                                TextEditor(text: $message)
                                    .frame(height: 150)
                                    .padding(8)
                                    .scrollContentBackground(.hidden)
                                    .background(themeManager.inputBgColor)
                                    .foregroundColor(themeManager.primaryTextColor)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Send Button
                        Button(action: {
                            // Mock send action
                            showSuccessAlert = true
                        }) {
                            Text(lm.t(.contactSend))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(themeManager.bgColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(isFormValid ? themeManager.accentYellow : Color.gray.opacity(0.3))
                                .cornerRadius(15)
                                .shadow(color: isFormValid ? themeManager.accentYellow.opacity(0.3) : .clear, radius: 10, x: 0, y: 5)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
            .onAppear {
                if fullName.isEmpty {
                    fullName = userNameStore
                }
            }
            .alert(lm.t(.contactSuccess), isPresented: $showSuccessAlert) {
                Button(lm.t(.alertOk), role: .cancel) { dismiss() }
            } message: {
                Text(lm.t(.contactSuccessSub))
            }
        }
    }
    
    private var isFormValid: Bool {
        !fullName.isEmpty && !email.isEmpty && !message.isEmpty
    }
}

struct ContactTextField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var themeManager: ThemeManager
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(themeManager.secondaryTextColor)
                .padding(.leading, 4)
            
            TextField(placeholder, text: $text)
                .padding(16)
                .background(themeManager.inputBgColor)
                .foregroundColor(themeManager.primaryTextColor)
                .keyboardType(keyboardType)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

#Preview {
    ContactUsView()
        .environmentObject(ThemeManager())
}
