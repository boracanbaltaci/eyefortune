import Combine
import Foundation
import SwiftUI

class FortuneViewModel: ObservableObject {
    @Published var dailyFortune: Fortune?
    @Published var loveFortune: Fortune?
    @Published var healthFortune: Fortune?
    @Published var wealthFortune: Fortune?
    @Published var careerFortune: Fortune?
    @Published var strengthsFortune: Fortune?
    @Published var weaknessesFortune: Fortune?
    @Published var personalityFortune: Fortune?
    
    @Published var isLoading: Bool = false
    private let openAIService = OpenAIService.shared
    
    // In a real app, this would use UserDefaults or CoreData
    @Published var savedFortunes: [Fortune] = [] {
        didSet {
            saveFortunes()
        }
    }
    
    private let saveKey = "saved_fortunes_list"
    
    init() {
        loadFortunes()
        loadCategorizedFortunes()
    }
    
    private func saveFortunes() {
        if let encoded = try? JSONEncoder().encode(savedFortunes) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadFortunes() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Fortune].self, from: data) {
            savedFortunes = decoded
        }
    }
    
    func fetchDailyFortune(user: User, language: AppLanguage) {
        isLoading = true
        let prompt = AIPromptGenerator.generateDailyFortunePrompt(user: user, language: language)
        
        openAIService.generateFortune(prompt: prompt) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let text):
                    let fortune = Fortune(text: text, dateGenerated: Date(), type: .daily, language: language)
                    self?.dailyFortune = fortune
                    self?.saveCategorizedFortune(fortune, key: "daily_fortune_cache")
                    NotificationManager.shared.sendDailyFortuneReadyNotification(language: language)
                case .failure(let error):
                    print("Daily Fortune Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchInsightFortune(type: Fortune.FortuneType, user: User, language: AppLanguage) {
        let prompt: String
        if type == .personality {
            prompt = AIPromptGenerator.generatePersonalityPrompt(user: user, language: language)
        } else {
            prompt = AIPromptGenerator.generateInsightPrompt(type: type, user: user, language: language)
        }
        
        openAIService.generateFortune(prompt: prompt) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let text):
                    let fortune = Fortune(text: text, dateGenerated: Date(), type: type, language: language)
                    switch type {
                    case .love:
                        self?.loveFortune = fortune
                        self?.saveCategorizedFortune(fortune, key: "love_fortune_cache")
                    case .health:
                        self?.healthFortune = fortune
                        self?.saveCategorizedFortune(fortune, key: "health_fortune_cache")
                    case .wealth:
                        self?.wealthFortune = fortune
                        self?.saveCategorizedFortune(fortune, key: "wealth_fortune_cache")
                    case .career:
                        self?.careerFortune = fortune
                        self?.saveCategorizedFortune(fortune, key: "career_fortune_cache")
                    case .strengths:
                        self?.strengthsFortune = fortune
                        self?.saveCategorizedFortune(fortune, key: "strengths_fortune_cache")
                    case .weaknesses:
                        self?.weaknessesFortune = fortune
                        self?.saveCategorizedFortune(fortune, key: "weaknesses_fortune_cache")
                    case .personality:
                        self?.personalityFortune = fortune
                        self?.saveCategorizedFortune(fortune, key: "personality_fortune_cache")
                    default: break
                    }
                case .failure(let error):
                    print("\(type.rawValue) Insight Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func saveCategorizedFortune(_ fortune: Fortune, key: String) {
        if let encoded = try? JSONEncoder().encode(fortune) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    private func loadCategorizedFortunes() {
        if let data = UserDefaults.standard.data(forKey: "daily_fortune_cache"),
           let decoded = try? JSONDecoder().decode(Fortune.self, from: data) {
            dailyFortune = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "love_fortune_cache"),
           let decoded = try? JSONDecoder().decode(Fortune.self, from: data) {
            loveFortune = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "health_fortune_cache"),
           let decoded = try? JSONDecoder().decode(Fortune.self, from: data) {
            healthFortune = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "wealth_fortune_cache"),
           let decoded = try? JSONDecoder().decode(Fortune.self, from: data) {
            wealthFortune = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "career_fortune_cache"),
           let decoded = try? JSONDecoder().decode(Fortune.self, from: data) {
            careerFortune = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "strengths_fortune_cache"),
           let decoded = try? JSONDecoder().decode(Fortune.self, from: data) {
            strengthsFortune = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "weaknesses_fortune_cache"),
           let decoded = try? JSONDecoder().decode(Fortune.self, from: data) {
            weaknessesFortune = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "personality_fortune_cache"),
           let decoded = try? JSONDecoder().decode(Fortune.self, from: data) {
            personalityFortune = decoded
        }
    }
    
    func toggleFavorite(_ fortune: Fortune) {
        if let index = savedFortunes.firstIndex(where: { $0.id == fortune.id }) {
            savedFortunes.remove(at: index)
        } else {
            savedFortunes.append(fortune)
        }
    }
    
    func clearCachesIfLanguageChanged(currentLanguage: AppLanguage) {
        if dailyFortune?.language != currentLanguage { dailyFortune = nil }
        if loveFortune?.language != currentLanguage { loveFortune = nil }
        if healthFortune?.language != currentLanguage { healthFortune = nil }
        if wealthFortune?.language != currentLanguage { wealthFortune = nil }
        if careerFortune?.language != currentLanguage { careerFortune = nil }
        if strengthsFortune?.language != currentLanguage { strengthsFortune = nil }
        if weaknessesFortune?.language != currentLanguage { weaknessesFortune = nil }
        if personalityFortune?.language != currentLanguage { personalityFortune = nil }
    }
}
