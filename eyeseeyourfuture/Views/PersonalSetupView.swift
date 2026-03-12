import SwiftUI

struct PersonalSetupView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("userName") var userNameStore: String = ""
    @State private var fullName = ""
    @State private var birthDate = ""
    @State private var birthTime = ""
    @State private var timePeriod = "AM"
    @State private var selectedElement: ElementType? = nil
    
    @State private var navigateToScanner = false
    @State private var dismissToMain = false
    @AppStorage("isSetupComplete") var isSetupComplete: Bool = false
    
    enum ElementType: String, CaseIterable {
        case fire = "Fire"
        case water = "Water"
        case air = "Air"
        case earth = "Earth"
        
        var icon: String {
            switch self {
            case .fire: return "flame.fill"
            case .water: return "drop.fill"
            case .air: return "wind"
            case .earth: return "leaf.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .fire: return .orange
            case .water: return .blue
            case .air: return .green
            case .earth: return .brown
            }
        }
    }
    
    private var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        birthDate.count == 10 && 
        !birthTime.isEmpty &&
        selectedElement != nil
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Stage Indicator
                    HStack(spacing: 12) {
                        Capsule().fill(themeManager.accentYellow).frame(width: 40, height: 6)
                        Capsule().fill(themeManager.accentYellow.opacity(0.2)).frame(width: 40, height: 6)
                        Capsule().fill(themeManager.accentYellow.opacity(0.2)).frame(width: 40, height: 6)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                        
                    // Header Texts
                    Text("Kozmik Kimlik")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 4)
                    
                    Text("Yıldız haritanı çizmek için temel bilgilerini gir.")
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 15)
                    
                    // Form Fields
                    VStack(spacing: 24) {
                        SetupTextField(title: lm.t(.setupFullName), placeholder: "Adınızı giriniz", text: $fullName, icon: nil, autocapitalization: .words)
                        
                        HStack(spacing: 12) {
                            SetupTextField(title: lm.t(.setupBirthDate), placeholder: "GG / AA / YYYY", text: $birthDate, icon: "calendar", keyboardType: .numberPad)
                                .onChange(of: birthDate) { _, newValue in
                                    formatDate(newValue)
                                }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(lm.t(.setupBirthTime))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .padding(.leading, 4)
                                
                                HStack(spacing: 0) {
                                    TextField("12:00", text: $birthTime, onEditingChanged: { isEditing in
                                        if !isEditing {
                                            completeBirthTime()
                                        }
                                    })
                                    .foregroundColor(themeManager.primaryTextColor)
                                    .keyboardType(.numbersAndPunctuation)
                                    .frame(maxWidth: .infinity)
                                    
                                    Button(action: {
                                        timePeriod = timePeriod == "AM" ? "PM" : "AM"
                                    }) {
                                        Text(timePeriod)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(themeManager.accentYellow)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(themeManager.accentYellow.opacity(0.1))
                                            .cornerRadius(6)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 16)
                                .background(themeManager.inputBgColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
                                )
                                .cornerRadius(15)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Evrendeki elementini seç:")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(themeManager.secondaryTextColor)
                                .padding(.leading, 4)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(ElementType.allCases, id: \.self) { element in
                                    ElementCard(
                                        element: element,
                                        isSelected: selectedElement == element,
                                        action: { selectedElement = element }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            if isFormValid {
                                // Save name to AppStorage before moving forward
                                userNameStore = fullName
                                navigateToScanner = true
                            }
                        }) {
                            Text(lm.t(.setupContinue))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(isFormValid ? themeManager.bgColor : .white.opacity(0.5))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(isFormValid ? themeManager.accentYellow : Color.gray.opacity(0.3))
                                .cornerRadius(15)
                                .shadow(color: isFormValid ? themeManager.accentYellow.opacity(0.3) : .clear, radius: 10, x: 0, y: 5)
                        }
                        .disabled(!isFormValid)
                        
                        Text("Adım 1 / 3: Ruhsal Hizalanma")
                            .font(.system(size: 12))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
            .navigationDestination(isPresented: $navigateToScanner) {
                PersonalityQuizView(navigateToNextStep: $dismissToMain)
            }
            .onChange(of: dismissToMain) { _, newValue in
                if newValue {
                    isSetupComplete = true
                    dismiss()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(themeManager.primaryTextColor)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(lm.t(.setupNavTitle))
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                }
            }
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            // Pre-fill if name already exists
            if fullName.isEmpty && !userNameStore.isEmpty {
                fullName = userNameStore
            }
        }
    }
    
    private func completeBirthTime() {
        let cleaned = birthTime.filter { "0123456789:".contains($0) }
        guard !cleaned.isEmpty else { return }
        
        let components = cleaned.split(separator: ":")
        var hour: Int = 0
        var minute: Int = 0
        
        if let h = Int(components[0]) {
            hour = h
        }
        
        if components.count >= 2, let m = Int(components[1]) {
            minute = m
        }
        
        if hour >= 24 {
            hour = hour % 24
        }
        
        if hour >= 12 {
            if hour > 12 {
                hour -= 12
            }
            timePeriod = "PM"
        } else {
            if hour == 0 { hour = 12 }
            timePeriod = "AM"
        }
        
        birthTime = String(format: "%d:%02d", hour, minute)
    }
    
    private func formatDate(_ value: String) {
        let clean = value.filter { "0123456789".contains($0) }
        var result = ""
        for (i, char) in clean.enumerated() {
            if i == 2 || i == 4 { result.append("/") }
            if i < 8 { result.append(char) }
        }
        if result != value || value.contains(where: { !$0.isNumber && $0 != "/" }) {
            birthDate = result
        }
    }
}

// MARK: - Reusable Setup Text Field
struct SetupTextField: View {
    @EnvironmentObject var themeManager: ThemeManager
    var title: String
    var placeholder: String
    @Binding var text: String
    var icon: String?
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .never
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(themeManager.secondaryTextColor)
                .padding(.leading, 4)
            
            HStack {
                TextField(placeholder, text: $text)
                    .foregroundColor(themeManager.primaryTextColor)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(themeManager.inputBgColor)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(15)
        }
    }
}

// MARK: - Element Selection Card
struct ElementCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    var element: PersonalSetupView.ElementType
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(element.color.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: element.icon)
                        .foregroundColor(element.color)
                        .font(.system(size: 24))
                }
                
                Text(element.rawValue)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(themeManager.primaryTextColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? themeManager.accentYellow.opacity(0.15) : themeManager.cardBgColor)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? themeManager.accentYellow : themeManager.accentYellow.opacity(0.1), lineWidth: isSelected ? 2 : 1)
            )
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
