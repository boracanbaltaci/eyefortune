import SwiftUI
import Combine

// MARK: - Models
struct QuizQuestion: Identifiable {
    let id = UUID()
    let text: String
    let category: String
}

enum QuizAnswer: String, Codable {
    case yes = "Evet"
    case no = "Hayır"
}

// MARK: - ViewModel
class PersonalityQuizViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var answers: [UUID: QuizAnswer] = [:]
    @Published var isAnalyzing = false
    @Published var analysisComplete = false
    
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
    
    var currentQuestion: QuizQuestion {
        questions[currentIndex]
    }
    
    var progress: Double {
        Double(currentIndex) / Double(questions.count - 1)
    }
    
    var isLastQuestion: Bool {
        currentIndex == questions.count - 1
    }
    
    func answerCurrentQuestion(with answer: QuizAnswer) {
        answers[currentQuestion.id] = answer
        
        if !isLastQuestion {
            withAnimation(.spring()) {
                currentIndex += 1
            }
        }
    }
    
    func startAnalysis() {
        isAnalyzing = true
        // Simulate AI analysis delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                self.isAnalyzing = false
                self.analysisComplete = true
            }
        }
    }
}

// MARK: - View
struct PersonalityQuizView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel = PersonalityQuizViewModel()
    
    @Binding var navigateToNextStep: Bool
    @Environment(\.presentationMode) var presentationMode
    
    @State private var analysisProgress: CGFloat = 0
    @State private var navigateToScanner = false
    
    var body: some View {
        ZStack {
            themeManager.bgColor.edgesIgnoringSafeArea(.all)
            
            if viewModel.isAnalyzing {
                analysisLoadingView
            } else {
                quizContent
            }
        }
        .navigationDestination(isPresented: $navigateToScanner) {
            EyeScannerCameraView(navigateToMainApp: $navigateToNextStep)
                .navigationBarHidden(true)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if viewModel.currentIndex > 0 && !viewModel.isAnalyzing {
                        withAnimation {
                            viewModel.currentIndex -= 1
                        }
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(themeManager.primaryTextColor)
                        .font(.system(size: 20, weight: .regular))
                }
            }
        }
        .toolbarBackground(themeManager.bgColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onChange(of: viewModel.isAnalyzing) { _, newValue in
            if newValue {
                startAnalysisAnimation()
            }
        }
        .onChange(of: viewModel.analysisComplete) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navigateToScanner = true
                }
            }
        }
    }
    
    private func startAnalysisAnimation() {
        analysisProgress = 0
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if analysisProgress < 1.0 {
                analysisProgress += 0.01
            } else {
                timer.invalidate()
            }
        }
    }
    
    // MARK: - Subviews
    private var quizContent: some View {
        VStack(spacing: 0) {
            // Stage Indicator (Synced with PersonalSetupView)
            HStack(spacing: 12) {
                Capsule().fill(themeManager.accentYellow.opacity(0.4)).frame(width: 40, height: 6)
                Capsule().fill(themeManager.accentYellow).frame(width: 40, height: 6)
                Capsule().fill(themeManager.accentYellow.opacity(0.2)).frame(width: 40, height: 6)
            }
            .padding(.top, 20)
            
            Text("İçsel Hassasiyet")
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundColor(themeManager.primaryTextColor)
                .multilineTextAlignment(.center)
                .padding(.top, 40)
                .padding(.bottom, 8)
            
            Text("Seni tanıyıp sana özel fallar bulmak ve yıldızları ona göre analiz etmek için bu testi yap.")
                .font(.system(size: 14))
                .foregroundColor(themeManager.secondaryTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 24)
            
            // Progress Section
            VStack(spacing: 12) {
                HStack {
                    Text("Soru \(viewModel.currentIndex + 1) / \(viewModel.questions.count)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(themeManager.secondaryTextColor)
                    Spacer()
                    Text(viewModel.currentQuestion.category.uppercased())
                        .font(.system(size: 11, weight: .black))
                        .tracking(2)
                        .foregroundColor(themeManager.accentYellow)
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(themeManager.inputBgColor)
                            .frame(height: 6)
                            .cornerRadius(3)
                        
                        Rectangle()
                            .fill(themeManager.accentYellow)
                            .frame(width: geometry.size.width * CGFloat(viewModel.progress), height: 6)
                            .cornerRadius(3)
                            .animation(.spring(), value: viewModel.progress)
                    }
                }
                .frame(height: 6)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Question Center Piece
            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(themeManager.accentYellow.opacity(0.1), lineWidth: 1)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundColor(themeManager.accentYellow.opacity(0.5))
                }
                
                Text(viewModel.currentQuestion.text)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .lineLimit(5)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.center)
                    .foregroundColor(themeManager.primaryTextColor)
                    .padding(.horizontal, 24)
                    .frame(height: 140)
                    .id(viewModel.currentIndex)
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
            }
            
            Spacer()
            
            // Interaction Buttons
            VStack(spacing: 20) {
                if viewModel.isLastQuestion && viewModel.answers[viewModel.currentQuestion.id] != nil {
                    Button(action: {
                        viewModel.startAnalysis()
                    }) {
                        Text("Cevaplarımı Kaydet")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(themeManager.bgColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(themeManager.accentYellow)
                            .cornerRadius(15)
                            .shadow(color: themeManager.accentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .transition(.opacity)
                } else {
                    HStack(spacing: 20) {
                        AnswerButton(themeManager: themeManager, answer: .no, isSelected: viewModel.answers[viewModel.currentQuestion.id] == .no) {
                            viewModel.answerCurrentQuestion(with: .no)
                        }
                        
                        AnswerButton(themeManager: themeManager, answer: .yes, isSelected: viewModel.answers[viewModel.currentQuestion.id] == .yes) {
                            viewModel.answerCurrentQuestion(with: .yes)
                        }
                    }
                }
                
                Text("Adım 2 / 3: İçsel Yansıma")
                    .font(.system(size: 12))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .padding(.top, 10)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
    }
    
    private var analysisLoadingView: some View {
        VStack(spacing: 40) {
            ZStack {
                Circle()
                    .stroke(themeManager.accentYellow.opacity(0.1), lineWidth: 2)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0.0, to: analysisProgress)
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [themeManager.accentYellow, .white]), startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear(duration: 0.1), value: analysisProgress)
                
                VStack(spacing: 8) {
                    Text("\(Int(analysisProgress * 100))%")
                        .font(.system(size: 48, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    Text("TAMAMLANIYOR")
                        .font(.system(size: 10, weight: .black))
                        .tracking(2)
                        .foregroundColor(themeManager.accentYellow)
                }
            }
            
            VStack(spacing: 16) {
                Text("Ruhun Analiz Ediliyor")
                    .font(.system(size: 26, weight: .bold, design: .serif))
                    .foregroundColor(themeManager.primaryTextColor)
                
                Text(analysisProgress < 0.5 ? "Cevaplarınız evrensel elementlerle eşleştiriliyor..." : "Kozmik frekansınız yıldızlarla senkronize ediliyor...")
                    .font(.system(size: 15))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    .id(analysisProgress < 0.5)
                    .transition(.opacity)
            }
        }
    }
}

struct AnswerButton: View {
    @ObservedObject var themeManager: ThemeManager
    let answer: QuizAnswer
    let isSelected: Bool
    let action: () -> Void
    
    var color: Color {
        switch answer {
        case .yes: return Color(hex: "4CAF50") // Green-ish
        case .no: return Color(hex: "F44336") // Red-ish
        }
    }
    
    var icon: String {
        switch answer {
        case .yes: return "checkmark"
        case .no: return "xmark"
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : themeManager.inputBgColor)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isSelected ? .white : color)
                }
                
                Text(answer.rawValue)
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(isSelected ? color : themeManager.primaryTextColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 4)
            .background(isSelected ? color.opacity(0.1) : themeManager.cardBgColor)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? color : themeManager.accentYellow.opacity(0.1), lineWidth: isSelected ? 2 : 1)
            )
            .cornerRadius(16)
            .shadow(color: isSelected ? color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Color(hex:) is defined in Extensions.swift

#Preview {
    PersonalityQuizView(navigateToNextStep: .constant(false))
        .environmentObject(ThemeManager())
}
