import SwiftUI

struct PersonalSetupView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("userName") var userNameStore: String = ""
    @AppStorage("userBirthTime") var userBirthTimeStore: String = ""
    @AppStorage("userBirthDate") var userBirthDateStore: String = ""
    @AppStorage("userZodiac") var userZodiacStore: String = ""
    @AppStorage("userElement") var userElementStore: String = ""
    @State private var fullName = ""
    @State private var birthDate = ""
    @State private var birthTime = ""
    @State private var timePeriod = "AM"
    @State private var selectedElement: ElementType? = nil
    
    @State private var navigateToScanner = false
    @State private var dismissToMain = false
    @State private var attemptedContinue = false
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
        isDateValid &&
        !birthTime.isEmpty &&
        selectedElement != nil
    }
    
    private var isDateValid: Bool {
        let components = birthDate.split(separator: "/")
        guard components.count == 3 else { return false }
        
        guard let day = Int(components[0]),
              let month = Int(components[1]),
              let year = Int(components[2]) else { return false }
        
        // Basic range checks
        guard month >= 1 && month <= 12 else { return false }
        
        let now = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: now)
        
        guard year >= 1900 && year <= currentYear else { return false }
        
        let dateComponents = DateComponents(year: year, month: month, day: day)
        guard let date = calendar.date(from: dateComponents), dateComponents.isValidDate(in: calendar) else {
            return false
        }
        
        // Ensure not in the future
        return date <= now
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // 3-Step Navigator
                            StepNavigator(currentStep: 1, themeManager: themeManager)
                            
                            // Centered Content Container
                            VStack(spacing: 24) {
                                // Header Texts
                                VStack(spacing: 8) {
                                    Text("Kozmik Kimlik")
                                        .font(.system(size: 28, weight: .bold, design: .serif))
                                        .foregroundColor(themeManager.primaryTextColor)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Yıldız haritanı çizmek için temel bilgilerini gir.")
                                        .font(.system(size: 13))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                }
                                
                                // Form Fields
                                VStack(spacing: 24) {
                                    SetupTextField(title: lm.t(.setupFullName), placeholder: "Adınızı giriniz", text: $fullName, icon: nil, autocapitalization: .words, isError: attemptedContinue && fullName.trimmingCharacters(in: .whitespaces).isEmpty)
                                    
                                    HStack(spacing: 12) {
                                        SetupTextField(title: lm.t(.setupBirthDate), placeholder: "GG / AA / YYYY", text: $birthDate, icon: "calendar", keyboardType: .numberPad, isError: attemptedContinue && !isDateValid)
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
                                                .onChange(of: birthTime) { _, newValue in
                                                    formatTime(newValue)
                                                }
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
                                                    .stroke((attemptedContinue && birthTime.isEmpty) ? Color.red : themeManager.accentYellow.opacity(0.2), lineWidth: (attemptedContinue && birthTime.isEmpty) ? 1.5 : 1)
                                            )
                                            .cornerRadius(15)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Sana yakın hissettiğin elementi seç:")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(themeManager.secondaryTextColor)
                                            .padding(.leading, 4)
                                        
                                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                            ForEach(ElementType.allCases, id: \.self) { element in
                                                ElementCard(
                                                    element: element,
                                                    isSelected: selectedElement == element,
                                                    isError: attemptedContinue && selectedElement == nil,
                                                    action: { selectedElement = element }
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            Spacer(minLength: 30)
                            
                            VStack(spacing: 16) {
                                Button(action: {
                                    attemptedContinue = true
                                    if isFormValid {
                                        userNameStore = fullName
                                        userBirthTimeStore = "\(birthTime) \(timePeriod)"
                                        userBirthDateStore = birthDate
                                        userElementStore = selectedElement?.rawValue ?? ""
                                        userZodiacStore = calculateZodiac(from: birthDate)
                                        navigateToScanner = true
                                    }
                                }) {
                                    Text(lm.t(.setupContinue))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(isFormValid ? themeManager.bgColor : .white.opacity(0.5))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 18)
                                        .background(isFormValid ? themeManager.accentYellow : themeManager.accentYellow.opacity(0.3))
                                        .cornerRadius(15)
                                        .shadow(color: isFormValid ? themeManager.accentYellow.opacity(0.3) : .clear, radius: 10, x: 0, y: 5)
                                }
                                
                                
                                Text("Adım 1 / 3: Ruhsal Hizalanma")
                                    .font(.system(size: 12))
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                        }
                        .frame(minHeight: geometry.size.height)
                    }
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
            .onAppear {
                // Pre-fill if name already exists
                if fullName.isEmpty && !userNameStore.isEmpty {
                    fullName = userNameStore
                }
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
            if i == 0 {
                // First digit of day: can't be > 3 (assuming GG/AA/YYYY)
                if let digit = Int(String(char)), digit > 3 { continue }
            }
            if i == 1 {
                // Second digit of day: if first digit is 3, second must be 0 or 1
                let firstDigit = Int(String(clean.prefix(1))) ?? 0
                let secondDigit = Int(String(char)) ?? 0
                if firstDigit == 3 && secondDigit > 1 { continue }
            }
            if i == 2 {
                // First digit of month: max 1
                if let digit = Int(String(char)), digit > 1 { continue }
            }
            if i == 3 {
                // Second digit of month: if first digit is 1, second max 2
                let firstDigit = Int(String(clean.dropFirst(2).prefix(1))) ?? 0
                let secondDigit = Int(String(char)) ?? 0
                if firstDigit == 1 && secondDigit > 2 { continue }
            }
            
            if i == 2 || i == 4 { result.append("/") }
            if i < 8 { result.append(char) }
        }
        
        if result != value || value.contains(where: { !$0.isNumber && $0 != "/" }) {
            birthDate = result
        }
    }
    
    private func formatTime(_ value: String) {
        let clean = value.filter { "0123456789".contains($0) }
        var result = ""
        
        for (i, char) in clean.enumerated() {
            if i == 0 {
                // First digit of hour: max 2 (for 24h) or 1 (for 12h)
                // Let's assume 12h as shown in AM/PM toggle
                if let digit = Int(String(char)), digit > 1 { continue }
            }
            if i == 1 {
                // Second digit of hour: if first digit is 1, second max 2
                let firstDigit = Int(String(clean.prefix(1))) ?? 0
                let secondDigit = Int(String(char)) ?? 0
                if firstDigit == 1 && secondDigit > 2 { continue }
            }
            if i == 2 {
                // First digit of minute: max 5
                if let digit = Int(String(char)), digit > 5 { continue }
            }

            if i == 2 { result.append(":") }
            if i < 4 { result.append(char) }
        }
        
        if result != value || value.contains(where: { !$0.isNumber && $0 != ":" }) {
            birthTime = result
        }
    }
    
    private func calculateZodiac(from dateStr: String) -> String {
        let components = dateStr.split(separator: "/")
        guard components.count >= 2,
              let day = Int(components[0]),
              let month = Int(components[1]) else { return "Bilinmiyor" }
        
        switch (month, day) {
        case (1, 20...31), (2, 1...18): return "Kova"
        case (2, 19...29), (3, 1...20): return "Balık"
        case (3, 21...31), (4, 1...19): return "Koç"
        case (4, 20...30), (5, 1...20): return "Boğa"
        case (5, 21...31), (6, 1...20): return "İkizler"
        case (6, 21...30), (7, 1...22): return "Yengeç"
        case (7, 23...31), (8, 1...22): return "Aslan"
        case (8, 23...31), (9, 1...22): return "Başak"
        case (9, 23...30), (10, 1...22): return "Terazi"
        case (10, 23...31), (11, 1...21): return "Akrep"
        case (11, 22...30), (12, 1...21): return "Yay"
        case (12, 22...31), (1, 1...19): return "Oğlak"
        default: return "Bilinmiyor"
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
    var isError: Bool = false
    
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
                    .stroke(isError ? Color.red : themeManager.accentYellow.opacity(0.2), lineWidth: isError ? 1.5 : 1)
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
    var isError: Bool = false
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
                    .stroke(isSelected ? themeManager.accentYellow : (isError ? Color.red.opacity(0.5) : themeManager.accentYellow.opacity(0.1)), lineWidth: (isSelected || isError) ? 2 : 1)
            )
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PersonalSetupView()
        .environmentObject(ThemeManager())
}
