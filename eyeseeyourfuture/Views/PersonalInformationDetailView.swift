import SwiftUI

struct PersonalInformationDetailView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("userName") var fullName: String = ""
    @AppStorage("userBirthDate") var birthDate: String = ""
    @AppStorage("irisColorName") var irisColorName: String = ""
    @AppStorage("irisHex") var irisHex: String = "#4A90E2"
    
    @AppStorage("lastPersonalDataEditDate") var lastPersonalEdit: Double = 0
    @AppStorage("lastQuizEditDate") var lastQuizEdit: Double = 0
    
    @State private var quizAnswers: [UUID: QuizAnswer] = [:]
    
    @State private var isEditingPersonal = false
    @State private var tempFullName = ""
    @State private var tempBirthDate = ""
    
    @State private var isEditingQuiz = false
    @State private var tempQuizAnswers: [UUID: QuizAnswer] = [:]
    
    // Questions from PersonalityQuizViewModel for reference
    let questions: [QuizQuestion] = [
        QuizQuestion(text: "Yeni bir yere gittiğimde önce etrafımdaki enerjiyi hissederim.", category: "Sezgi"),
        QuizQuestion(text: "Karar verirken mantığımdan çok iç sesime güvenirim.", category: "Karar Verme"),
        QuizQuestion(text: "Rüyalarımın çoğu zaman gerçekleştiğine şahit olurum.", category: "Sezgi"),
        QuizQuestion(text: "Kalabalık ortamlarda insanların duygularını hemen anlarım.", category: "Empati"),
        QuizQuestion(text: "Doğada vakit geçirmek ruhumu her zaman tazeler.", category: "Enerji"),
        QuizQuestion(text: "Küçük detaylar yerine büyük resme odaklanmayı tercih ederim.", category: "Algı"),
        QuizQuestion(text: "Başkalarına yardım etmek bana derin bir huzur verir.", category: "Empati"),
        QuizQuestion(text: "Planlarımın aniden değişmesi beni endişelendirmez.", category: "Esneklik"),
        QuizQuestion(text: "Yalnız kalmak benim için bir ihtiyaçtır.", category: "İçsel Denge"),
        QuizQuestion(text: "Geçmişteki hatalarımdan ders çıkarmak benim için kolaydır.", category: "Gelişim"),
        QuizQuestion(text: "Gelecek hakkında düşünürken genellikle heyecanlıyımdır.", category: "Bakış Açısı"),
        QuizQuestion(text: "Yaratıcı projeler üretmek beni motive eder.", category: "Yaratıcılık"),
        QuizQuestion(text: "İnsanların niyetlerini bakışlarından anlayabilirim.", category: "Sezgi"),
        QuizQuestion(text: "Hayatımda tesadüflere değil, eşzamanlılıklara inanırım.", category: "İnanç"),
        QuizQuestion(text: "Farklı görüşlere sahip insanlarla kolayca anlaşabilirim.", category: "Sosyal"),
        QuizQuestion(text: "Sabah saatleri benim için en verimli vakitlerdir.", category: "Ritim"),
        QuizQuestion(text: "Bir işe başlamadan önce tüm riskleri hesaplamayı severim.", category: "Mantık"),
        QuizQuestion(text: "Mistik ve gizemli konular her zaman ilgimi çekmiştir.", category: "Merak"),
        QuizQuestion(text: "Kendimi ifade ederken sanatsal yolları tercih ederim.", category: "Yaratıcılık"),
        QuizQuestion(text: "Hayatın bir amacı olduğuna ve her şeyin bir nedeni olduğuna inanırım.", category: "Felsefe")
    ]
    
    private var canEditPersonal: Bool {
        let oneMonth: TimeInterval = 30 * 24 * 60 * 60
        return Date().timeIntervalSince1970 - lastPersonalEdit > oneMonth || lastPersonalEdit == 0
    }
    
    private var canEditQuiz: Bool {
        let oneMonth: TimeInterval = 30 * 24 * 60 * 60
        return Date().timeIntervalSince1970 - lastQuizEdit > oneMonth || lastQuizEdit == 0
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
                                        lastPersonalEdit = Date().timeIntervalSince1970
                                        isEditingPersonal = false
                                    }
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.green)
                                }
                            } else {
                                Button(action: {
                                    tempFullName = fullName
                                    tempBirthDate = birthDate
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
                            } else {
                                InfoRow(title: "Ad Soyad", value: fullName, themeManager: themeManager)
                                InfoRow(title: "Doğum Tarihi", value: birthDate, themeManager: themeManager)
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
                            VStack(spacing: 8) {
                                ForEach(questions) { question in
                                    if let currentAnswer = isEditingQuiz ? tempQuizAnswers[question.id] : quizAnswers[question.id] {
                                        HStack(alignment: .top, spacing: 16) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(question.text)
                                                    .font(.system(size: 13))
                                                    .foregroundColor(themeManager.primaryTextColor)
                                                
                                                Text(question.category.uppercased())
                                                    .font(.system(size: 9, weight: .black))
                                                    .foregroundColor(themeManager.accentYellow.opacity(0.6))
                                                    .tracking(1)
                                            }
                                            
                                            Spacer()
                                            
                                            if isEditingQuiz {
                                                HStack(spacing: 8) {
                                                    QuizEditButton(title: "Evet", isSelected: currentAnswer == .yes) {
                                                        tempQuizAnswers[question.id] = .yes
                                                    }
                                                    QuizEditButton(title: "Hayır", isSelected: currentAnswer == .no) {
                                                        tempQuizAnswers[question.id] = .no
                                                    }
                                                }
                                            } else {
                                                Text(currentAnswer.rawValue)
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundColor(currentAnswer == .yes ? .green : .red)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background((currentAnswer == .yes ? Color.green : Color.red).opacity(0.1))
                                                    .cornerRadius(6)
                                            }
                                        }
                                        .padding(16)
                                        .background(themeManager.cardBgColor)
                                        .cornerRadius(12)
                                    }
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
           let decoded = try? JSONDecoder().decode([UUID: QuizAnswer].self, from: data) {
            quizAnswers = decoded
        }
    }
    
    private func saveQuizAnswers() {
        if let encoded = try? JSONEncoder().encode(quizAnswers) {
            UserDefaults.standard.set(encoded, forKey: "quizAnswers")
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
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? (title == "Evet" ? Color.green : Color.red) : Color.gray.opacity(0.1))
                .cornerRadius(8)
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
