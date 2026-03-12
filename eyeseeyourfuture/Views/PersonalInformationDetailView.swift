import SwiftUI

struct PersonalInformationDetailView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("userName") var fullName: String = ""
    @AppStorage("userBirthDate") var birthDate: String = ""
    @AppStorage("irisColorName") var irisColorName: String = ""
    @AppStorage("irisHex") var irisHex: String = "#4A90E2"
    
    @State private var quizAnswers: [UUID: QuizAnswer] = [:]
    
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
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // User Identity Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Kozmik Kimlik")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(themeManager.accentYellow.opacity(0.7))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 12) {
                                InfoRow(title: "Ad Soyad", value: fullName, themeManager: themeManager)
                                InfoRow(title: "Doğum Tarihi", value: birthDate, themeManager: themeManager)
                                
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
                            }
                        }
                        
                        // Quiz Results Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Kişilik Testi Cevapları")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(themeManager.accentYellow.opacity(0.7))
                                .padding(.leading, 4)
                            
                            if quizAnswers.isEmpty {
                                Text("Henüz test çözülmemiş.")
                                    .font(.system(size: 14))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .padding(.leading, 4)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(questions) { question in
                                        if let answer = quizAnswers[question.id] {
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
                                                
                                                Text(answer.rawValue)
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundColor(answer == .yes ? .green : .red)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background((answer == .yes ? Color.green : Color.red).opacity(0.1))
                                                    .cornerRadius(6)
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
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Kişisel Bilgiler")
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                }
                
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
                loadQuizAnswers()
            }
        }
    }
    
    private func loadQuizAnswers() {
        if let data = UserDefaults.standard.data(forKey: "quizAnswers"),
           let decoded = try? JSONDecoder().decode([UUID: QuizAnswer].self, from: data) {
            quizAnswers = decoded
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

#Preview {
    PersonalInformationDetailView()
        .environmentObject(ThemeManager())
}
