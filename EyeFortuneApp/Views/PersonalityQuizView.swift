import SwiftUI

// MARK: - Models
struct QuizQuestion: Identifiable {
    let id = UUID()
    let text: String
    let category: String
}

enum QuizAnswer: String, Codable {
    case yes = "Evet"
    case maybe = "Kararsızım"
    case no = "Hayır"
}

// MARK: - ViewModel
class PersonalityQuizViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var answers: [UUID: QuizAnswer] = [:]
    @Published var isAnalyzing = false
    @Published var analysisComplete = false
    
    let questions: [QuizQuestion] = [
        // Sosyal Enerji
        QuizQuestion(text: "Yeni insanlarla tanışmak bana enerji verir.", category: "Sosyal Enerji"),
        QuizQuestion(text: "Uzun süre yalnız kalmak beni rahatsız etmez.", category: "Sosyal Enerji"),
        QuizQuestion(text: "Kalabalık ortamlarda kendimi rahat hissederim.", category: "Sosyal Enerji"),
        QuizQuestion(text: "Sosyal etkinliklerden sonra yalnız kalma ihtiyacı hissederim.", category: "Sosyal Enerji"),
        QuizQuestion(text: "Sohbeti başlatan kişi genellikle ben olurum.", category: "Sosyal Enerji"),
        
        // Bilgi Algılama
        QuizQuestion(text: "Somut ve gerçek bilgiler bana daha güven verir.", category: "Bilgi Algılama"),
        QuizQuestion(text: "Hayal kurmak ve yeni fikirler düşünmek hoşuma gider.", category: "Bilgi Algılama"),
        QuizQuestion(text: "Detaylara dikkat etmek benim için önemlidir.", category: "Bilgi Algılama"),
        QuizQuestion(text: "Büyük resmi görmek detaylardan daha önemlidir.", category: "Bilgi Algılama"),
        QuizQuestion(text: "Yeni ve farklı fikirler üretmek beni heyecanlandırır.", category: "Bilgi Algılama"),
        
        // Karar Verme
        QuizQuestion(text: "Karar verirken mantık benim için en önemli faktördür.", category: "Karar Verme"),
        QuizQuestion(text: "İnsanların duygularını dikkate almak önemlidir.", category: "Karar Verme"),
        QuizQuestion(text: "Tartışmalarda mantıklı argümanlar benim için önemlidir.", category: "Karar Verme"),
        QuizQuestion(text: "Başkalarının incinmemesine dikkat ederim.", category: "Karar Verme"),
        QuizQuestion(text: "Analitik düşünmek bana daha doğal gelir.", category: "Karar Verme"),
        
        // Planlama Tarzı
        QuizQuestion(text: "Günümü önceden planlamayı severim.", category: "Planlama Tarzı"),
        QuizQuestion(text: "Son anda karar vermek benim için sorun değildir.", category: "Planlama Tarzı"),
        QuizQuestion(text: "Programlı olmak bana güven verir.", category: "Planlama Tarzı"),
        QuizQuestion(text: "Planların değişmesi beni rahatsız etmez.", category: "Planlama Tarzı"),
        QuizQuestion(text: "İşleri erken bitirmeyi tercih ederim.", category: "Planlama Tarzı")
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
        // Save answers to UserDefaults
        if let encoded = try? JSONEncoder().encode(answers) {
            UserDefaults.standard.set(encoded, forKey: "savedQuizAnswers")
        }
        
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
    
    @State private var navigateToScanner = false
    
    var body: some View {
        ZStack {
            themeManager.bgColor.edgesIgnoringSafeArea(.all)
            
            if viewModel.isAnalyzing {
                analysisLoadingView
            } else {
                quizContent
            }
            
            // Invisible Navigation Link to Next Step
            NavigationLink(
                destination: EyeScannerCameraView(navigateToMainApp: $navigateToNextStep).navigationBarHidden(true),
                isActive: $navigateToScanner
            ) {
                EmptyView()
            }
        }
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
            
            ToolbarItem(placement: .principal) {
                Text("Inner Star Reflection")
                    .font(.system(size: 17, weight: .bold, design: .serif))
                    .foregroundColor(themeManager.primaryTextColor)
            }
        }
        .toolbarBackground(themeManager.bgColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onChange(of: viewModel.analysisComplete) { isComplete in
            if isComplete {
                // When analysis completes, move to next step automatically
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navigateToScanner = true
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var quizContent: some View {
        VStack(spacing: 0) {
            // Stage Indicator (Step 2 of 3)
            HStack(spacing: 12) {
                Capsule().fill(themeManager.accentYellow.opacity(0.4)).frame(width: 40, height: 6)
                Capsule().fill(themeManager.accentYellow).frame(width: 40, height: 6)
                Capsule().fill(themeManager.accentYellow.opacity(0.2)).frame(width: 40, height: 6)
            }
            .padding(.top, 10)
            
            // Progress Text
            HStack {
                Text("Question \(viewModel.currentIndex + 1) of \(viewModel.questions.count)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(themeManager.secondaryTextColor)
                Spacer()
                Text(viewModel.currentQuestion.category)
                    .font(.system(size: 12, weight: .bold))
                    .tracking(1)
                    .foregroundColor(themeManager.accentYellow)
            }
            .padding(.horizontal, 24)
            .padding(.top, 30)
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(themeManager.inputBgColor)
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(themeManager.accentYellow)
                        .frame(width: geometry.size.width * CGFloat(viewModel.progress), height: 4)
                        .cornerRadius(2)
                        .animation(.spring(), value: viewModel.progress)
                }
            }
            .frame(height: 4)
            .padding(.horizontal, 24)
            .padding(.top, 10)
            
            Spacer()
            
            // Question Center Piece
            VStack(spacing: 40) {
                Image(systemName: "sparkles")
                    .font(.system(size: 40))
                    .foregroundColor(themeManager.accentYellow.opacity(0.5))
                
                Text(viewModel.currentQuestion.text)
                    .font(.system(size: 26, weight: .bold, design: .serif))
                    .lineLimit(4)
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
            VStack(spacing: 16) {
                if viewModel.isLastQuestion && viewModel.answers[viewModel.currentQuestion.id] != nil {
                    // Final Submit Button
                    Button(action: {
                        viewModel.startAnalysis()
                    }) {
                        Text("Kişiliğimi Analiz Et")
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
                    // Answer Options
                    HStack(spacing: 12) {
                        AnswerButton(themeManager: themeManager, answer: .no, isSelected: viewModel.answers[viewModel.currentQuestion.id] == .no) {
                            viewModel.answerCurrentQuestion(with: .no)
                        }
                        
                        AnswerButton(themeManager: themeManager, answer: .maybe, isSelected: viewModel.answers[viewModel.currentQuestion.id] == .maybe) {
                            viewModel.answerCurrentQuestion(with: .maybe)
                        }
                        
                        AnswerButton(themeManager: themeManager, answer: .yes, isSelected: viewModel.answers[viewModel.currentQuestion.id] == .yes) {
                            viewModel.answerCurrentQuestion(with: .yes)
                        }
                    }
                }
                
                Text("Step 2 of 3: Inner Reflection")
                    .font(.system(size: 12))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .padding(.top, 10)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 50)
        }
    }
    
    private var analysisLoadingView: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 4)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0.0, to: 0.7)
                    .stroke(themeManager.accentYellow, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(Angle(degrees: viewModel.isAnalyzing ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: viewModel.isAnalyzing)
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 40))
                    .foregroundColor(themeManager.primaryTextColor)
            }
            
            VStack(spacing: 10) {
                Text("Kişilik Analizi Yapılıyor")
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .foregroundColor(themeManager.primaryTextColor)
                
                Text("Cevaplarınız evrensel elementlerle eşleştiriliyor...")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.secondaryTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
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
        case .maybe: return themeManager.accentYellow
        case .no: return Color(hex: "F44336") // Red-ish
        }
    }
    
    var icon: String {
        switch answer {
        case .yes: return "checkmark"
        case .maybe: return "minus"
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
