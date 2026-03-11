import Foundation
import Combine
import SwiftUI

class FortuneViewModel: ObservableObject {
    @Published var dailyFortune: Fortune?
    @Published var isLoading: Bool = false
    
    // In a real app, this would use UserDefaults or CoreData
    @Published var savedFortunes: [Fortune] = []
    
    init() {
        fetchDailyFortune()
    }
    
    func fetchDailyFortune() {
        isLoading = true
        // Simulate network request or DB fetch delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let fortuneTexts = [
                "Bugün gözlerinde büyük bir yenilik ışığı var. Beklenmedik bir fırsata hazır ol.",
                "İçindeki güç bugün etrafındakilere de yansıyacak. Liderlik etme zamanı.",
                "Göz bebeklerindeki parıltı, yakın zamanda alacağın güzel bir habere işaret ediyor.",
                "Zihnin bugün çok berrak. Zor bir kararı vermek için en doğru zaman."
            ]
            
            let randomText = fortuneTexts.randomElement() ?? "Harika bir gün seni bekliyor."
            
            self.dailyFortune = Fortune(
                text: randomText,
                dateGenerated: Date(),
                type: .daily
            )
            self.isLoading = false
        }
    }
}
