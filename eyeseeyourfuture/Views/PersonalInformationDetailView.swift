import SwiftUI

struct PersonalInformationDetailView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("userName") var fullName: String = ""
    @AppStorage("userBirthDate") var birthDate: String = ""
    @AppStorage("userBirthTime") var birthTime: String = ""
    @AppStorage("userEmail") var userEmail: String = ""
    @AppStorage("irisColorName") var irisColorName: String = ""
    @AppStorage("irisHex") var irisHex: String = "#4A90E2"
    
    @AppStorage("lastPersonalDataEditDate") var lastPersonalEdit: Double = 0
    @AppStorage("lastQuizEditDate") var lastQuizEdit: Double = 0
    
    @AppStorage("hasCompletedInitialPersonalEdit") var hasCompletedInitialPersonalEdit = false
    @AppStorage("hasCompletedInitialQuizEdit") var hasCompletedInitialQuizEdit = false
    
    @State private var quizAnswers: [String: QuizAnswer] = [:]
    
    @State private var isEditingPersonal = false
    @State private var tempFullName = ""
    @State private var tempBirthDate = ""
    @State private var tempBirthTime = ""
    
    @State private var isEditingQuiz = false
    @State private var tempQuizAnswers: [String: QuizAnswer] = [:]
    
    // Questions from PersonalityQuizViewModel for reference
    let questions = PersonalityQuiz.questions
    
    private var canEditPersonal: Bool {
        if !hasCompletedInitialPersonalEdit { return true }
        let oneMonth: TimeInterval = 30 * 24 * 60 * 60
        return Date().timeIntervalSince1970 - lastPersonalEdit > oneMonth
    }
    
    private var canEditQuiz: Bool {
        if !hasCompletedInitialQuizEdit { return true }
        let oneMonth: TimeInterval = 30 * 24 * 60 * 60
        return Date().timeIntervalSince1970 - lastQuizEdit > oneMonth
    }
    
    var body: some View {
        ZStack {
            themeManager.bgColor.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // User Identity Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Kozmik Kimlik")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(themeManager.accentYellow.opacity(0.7))
                            
                            Spacer()
                            
                            if isEditingPersonal {
                                HStack(spacing: 12) {
                                    Button("İptal") {
                                        isEditingPersonal = false
                                    }
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.red)
                                    
                                    Button("Kaydet") {
                                        fullName = tempFullName
                                        birthDate = tempBirthDate
                                        birthTime = tempBirthTime
                                        lastPersonalEdit = Date().timeIntervalSince1970
                                        hasCompletedInitialPersonalEdit = true
                                        isEditingPersonal = false
                                    }
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.green)
                                }
                            } else {
                                Button(action: {
                                    tempFullName = fullName
                                    tempBirthDate = birthDate
                                    tempBirthTime = birthTime
                                    isEditingPersonal = true
                                }) {
                                    Text("Düzenle")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(themeManager.accentYellow)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(themeManager.accentYellow.opacity(0.1))
                                        .cornerRadius(8)
                                }
                                .disabled(!canEditPersonal)
                                .opacity(canEditPersonal ? 1 : 0.5)
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        if !canEditPersonal && !isEditingPersonal {
                            HStack(spacing: 8) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 12))
                                Text("Bilgiler ayda sadece 1 kez değiştirilebilir.")
                                    .font(.system(size: 11, weight: .medium))
                            }
                            .foregroundColor(themeManager.accentYellow.opacity(0.8))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(themeManager.accentYellow.opacity(0.05))
                            .cornerRadius(8)
                            .padding(.leading, 4)
                        }
                        
                        VStack(spacing: 12) {
                            if isEditingPersonal {
                                PersonalEditRow(title: "Ad Soyad", text: $tempFullName, themeManager: themeManager)
                                PersonalEditDateRow(title: "Doğum Tarihi", text: $tempBirthDate, themeManager: themeManager)
                                PersonalEditRow(title: "Doğum Saati", text: $tempBirthTime, themeManager: themeManager)
                            } else {
                                InfoRow(title: "Ad Soyad", value: fullName, themeManager: themeManager)
                                InfoRow(title: "Doğum Tarihi", value: birthDate, themeManager: themeManager)
                                InfoRow(title: "Doğum Saati", value: birthTime.isEmpty ? "Girilmedi" : birthTime, themeManager: themeManager)
                                InfoRow(title: "Hesap", value: userEmail.isEmpty ? "Apple ID" : censorEmail(userEmail), themeManager: themeManager)
                            }
                            
                            HStack {
                                Text("Göz Rengi")
                                    .font(.system(size: 15))
                                    .foregroundColor(themeManager.primaryTextColor)
                                Spacer()
                                HStack {
                                    Circle()
                                        .fill(Color(hex: irisHex))
                                        .frame(width: 20, height: 20)
                                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                                    
                                    Text(irisColorName)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(themeManager.accentYellow)
                                }
                            }
                            .padding(16)
                            .background(themeManager.cardBgColor)
                            .cornerRadius(12)
                            
                            Text("Göz rengi yalnızca analiz ile güncellenebilir.")
                                .font(.system(size: 10))
                                .foregroundColor(themeManager.secondaryTextColor.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 4)
                        }
                    }
                    
                    // Quiz Results Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Kişilik Testi Cevapları")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(themeManager.accentYellow.opacity(0.7))
                            
                            Spacer()
                            
                            if isEditingQuiz {
                                HStack(spacing: 12) {
                                    Button("İptal") {
                                        isEditingQuiz = false
                                    }
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.red)
                                    
                                    Button("Kaydet") {
                                        quizAnswers = tempQuizAnswers
                                        saveQuizAnswers()
                                        lastQuizEdit = Date().timeIntervalSince1970
                                        hasCompletedInitialQuizEdit = true
                                        isEditingQuiz = false
                                    }
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.green)
                                }
                            } else {
                                Button(action: {
                                    tempQuizAnswers = quizAnswers
                                    isEditingQuiz = true
                                }) {
                                    Text("Düzenle")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(themeManager.accentYellow)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(themeManager.accentYellow.opacity(0.1))
                                        .cornerRadius(8)
                                }
                                .disabled(!canEditQuiz)
                                .opacity(canEditQuiz ? 1 : 0.5)
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        if !canEditQuiz && !isEditingQuiz {
                            HStack(spacing: 8) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 12))
                                Text("Cevaplar ayda sadece 1 kez değiştirilebilir.")
                                    .font(.system(size: 11, weight: .medium))
                            }
                            .foregroundColor(themeManager.accentYellow.opacity(0.8))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(themeManager.accentYellow.opacity(0.05))
                            .cornerRadius(8)
                            .padding(.leading, 4)
                        }
                        
                        if quizAnswers.isEmpty {
                            Text("Henüz test çözülmemiş.")
                                .font(.system(size: 14))
                                .foregroundColor(themeManager.secondaryTextColor)
                                .padding(.leading, 4)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(questions) { question in
                                    let answer = isEditingQuiz ? tempQuizAnswers[question.id] : quizAnswers[question.id]
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack(alignment: .top, spacing: 16) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(question.text)
                                                    .font(.system(size: 14, weight: .medium, design: .serif))
                                                    .foregroundColor(themeManager.primaryTextColor)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                Text(question.category.uppercased())
                                                    .font(.system(size: 9, weight: .black))
                                                    .foregroundColor(themeManager.accentYellow.opacity(0.6))
                                                    .tracking(1.5)
                                            }
                                            
                                            Spacer()
                                            
                                            if !isEditingQuiz {
                                                Text(answer?.rawValue ?? "Girilmedi")
                                                    .font(.system(size: 11, weight: .bold))
                                                    .foregroundColor((answer == .yes ? Color.green : Color.red).opacity(0.8))
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background((answer == .yes ? Color.green : Color.red).opacity(0.1))
                                                    .cornerRadius(6)
                                            }
                                        }
                                        
                                        if isEditingQuiz {
                                            HStack(spacing: 12) {
                                                QuizEditButton(title: "Evet", isSelected: answer == .yes) {
                                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                        tempQuizAnswers[question.id] = .yes
                                                    }
                                                }
                                                
                                                QuizEditButton(title: "Hayır", isSelected: answer == .no) {
                                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                        tempQuizAnswers[question.id] = .no
                                                    }
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.top, 4)
                                        }
                                    }
                                    .padding(16)
                                    .background(themeManager.cardBgColor)
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(isEditingQuiz ? themeManager.accentYellow.opacity(0.2) : themeManager.accentYellow.opacity(0.05), lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(16)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Kişisel Bilgiler")
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .foregroundColor(themeManager.primaryTextColor)
            }
        }
        .toolbarBackground(themeManager.bgColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            loadQuizAnswers()
        }
    }
    
    private func loadQuizAnswers() {
        if let data = UserDefaults.standard.data(forKey: "quizAnswers"),
           let decoded = try? JSONDecoder().decode([String: QuizAnswer].self, from: data) {
            quizAnswers = decoded
        }
    }
    
    private func saveQuizAnswers() {
        if let encoded = try? JSONEncoder().encode(quizAnswers) {
            UserDefaults.standard.set(encoded, forKey: "quizAnswers")
            
            // Re-summarize for AI
            var categoryResults: [String: [QuizAnswer]] = [:]
            for question in PersonalityQuiz.questions {
                if let answer = quizAnswers[question.id] {
                    categoryResults[question.category, default: []].append(answer)
                }
            }
            
            var summary: [String: String] = [:]
            for (category, answers) in categoryResults {
                let yesCount = answers.filter { $0 == .yes }.count
                let total = answers.count
                summary[category] = "\(total) sorudan \(yesCount) tanesine 'Evet' dedi."
            }
            
            if let encodedSummary = try? JSONEncoder().encode(summary) {
                UserDefaults.standard.set(encodedSummary, forKey: "quizResultsSummary")
            }
        }
    }
    
    private func censorEmail(_ email: String) -> String {
        guard !email.isEmpty else { return "Girilmedi" }
        let components = email.split(separator: "@")
        guard components.count == 2 else { return email }
        
        let user = String(components[0])
        let domain = String(components[1])
        
        if user.count <= 2 {
            return user + "***@" + domain
        } else {
            let start = user.prefix(1)
            return start + "***@" + domain
        }
    }
}

struct PersonalEditRow: View {
    var title: String
    @Binding var text: String
    var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(themeManager.secondaryTextColor)
            TextField(title, text: $text)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(themeManager.accentYellow)
                .padding(12)
                .background(themeManager.inputBgColor)
                .cornerRadius(10)
        }
        .padding(16)
        .background(themeManager.cardBgColor)
        .cornerRadius(12)
    }
}

struct PersonalEditDateRow: View {
    var title: String
    @Binding var text: String
    var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(themeManager.secondaryTextColor)
            TextField("GG / AA / YYYY", text: $text)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(themeManager.accentYellow)
                .keyboardType(.numberPad)
                .padding(12)
                .background(themeManager.inputBgColor)
                .cornerRadius(10)
                .onChange(of: text) { _, newValue in
                    formatDate(newValue)
                }
        }
        .padding(16)
        .background(themeManager.cardBgColor)
        .cornerRadius(12)
    }
    
    private func formatDate(_ value: String) {
        let clean = value.filter { "0123456789".contains($0) }
        var result = ""
        for (i, char) in clean.enumerated() {
            if i == 2 || i == 4 { result.append("/") }
            if i < 8 { result.append(char) }
        }
        if result != value || value.contains(where: { !$0.isNumber && $0 != "/" }) {
            text = result
        }
    }
}

struct QuizEditButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: title == "Evet" ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 12))
                
                Text(title)
                    .font(.system(size: 12, weight: .bold))
            }
            .foregroundColor(isSelected ? .white : (title == "Evet" ? Color.green : Color.red).opacity(0.6))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                ZStack {
                    if isSelected {
                        (title == "Evet" ? Color.green : Color.red)
                    } else {
                        (title == "Evet" ? Color.green : Color.red).opacity(0.05)
                    }
                }
            )
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? .clear : (title == "Evet" ? Color.green : Color.red).opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct InfoRow: View {
    var title: String
    var value: String
    var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(themeManager.primaryTextColor)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(themeManager.accentYellow)
        }
        .padding(16)
        .background(themeManager.cardBgColor)
        .cornerRadius(12)
    }
}
