import Foundation
import Combine

class ScannerViewModel: ObservableObject {
    @Published var scanProgress: Double = 0.0
    @Published var isScanning: Bool = false
    @Published var isAligning: Bool = false
    @Published var scanComplete: Bool = false
    @Published var generatedFortune: Fortune?
    
    private let openAIService = OpenAIService.shared
    
    func startScan(language: AppLanguage) {
        isScanning = true
        isAligning = true
        scanProgress = 0.0
        scanComplete = false
        generatedFortune = nil
        
        // Simulating sensitivity: Wait 2 seconds for "alignment"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            self.isAligning = false
            
            // Simulate scan progress
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                if self.scanProgress >= 1.0 {
                    timer.invalidate()
                    self.processScanWithAI(language: language)
                } else {
                    self.scanProgress += 0.05
                }
            }
        }
    }
    
    private func processScanWithAI(language: AppLanguage) {
        // Fetch user context from UserDefaults
        let name = UserDefaults.standard.string(forKey: "userName")
        let birthTime = UserDefaults.standard.string(forKey: "userBirthTime")
        let birthDateStr = UserDefaults.standard.string(forKey: "userBirthDate")
        let zodiac = UserDefaults.standard.string(forKey: "userZodiac")
        let element = UserDefaults.standard.string(forKey: "userElement")
        
        var quizResults: [String: String]? = nil
        if let data = UserDefaults.standard.data(forKey: "quizResultsSummary") {
            quizResults = try? JSONDecoder().decode([String: String].self, from: data)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let birthDate = birthDateStr != nil ? formatter.date(from: birthDateStr!) : nil
        
        let userContext = User(
            name: name,
            birthDate: birthDate,
            birthTime: birthTime,
            zodiacSign: zodiac,
            element: element,
            personalityQuizResults: quizResults
        )
        
        let prompt = AIPromptGenerator.generatePersonalityPrompt(user: userContext, language: language)
        
        openAIService.generateFortune(prompt: prompt) { [weak self] result in
            DispatchQueue.main.async {
                self?.isScanning = false
                self?.scanComplete = true
                
                switch result {
                case .success(let text):
                    let fortune = Fortune(text: text, dateGenerated: Date(), type: .personality, language: language)
                    self?.generatedFortune = fortune
                    UserDefaults.standard.set(text, forKey: "irisReading")
                    if let encoded = try? JSONEncoder().encode(fortune) {
                        UserDefaults.standard.set(encoded, forKey: "personality_fortune_cache")
                    }
                case .failure(let error):
                    print("AI Error: \(error.localizedDescription)")
                    self?.generatedFortune = Fortune(text: "Yıldızlar şu an çok parlak, birazdan tekrar dene. (Hata: \(error.localizedDescription))", dateGenerated: Date(), type: .personality, language: language)
                }
            }
        }
    }
}
