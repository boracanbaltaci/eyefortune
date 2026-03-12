import Foundation
import Combine
import SwiftUI

class AIService {
    
    /// Simulates sending eye scan data to an AI backend and receiving a personalized fortune
    func analyzeEyeScan(imageData: Data, completion: @escaping (Fortune) -> Void) {
        // Simulate network delay for AI processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let aiFortunes = [
                "Göz irisindeki desenler yapay zeka analizine göre yoğun bir spiritüel enerji taşıyor. Bu hafta sevdiklerinle bağların güçlenecek.",
                "Retina yapın detaycı bir karaktere sahip olduğunu gösteriyor. Yakın zamanda detaylarda gizli bir fırsat yakalayacaksın.",
                "Yüzde 98 netlikle, göz yorgunluğun son günlerde fazla çalıştığını söylüyor. Biraz dinlenmelisin; büyük bir finansal kazanç ufukta.",
                "AI modelimiz göz bebeği dilasyonunu analiz etti: Heyecan verici bir gelişme yaşayacaksın ve bu tüm hayat enerjini yükseltecek."
            ]
            let randomText = aiFortunes.randomElement() ?? "Yıldızlar seninle."
            
            let fortune = Fortune(text: randomText, dateGenerated: Date(), type: .aiScan)
            completion(fortune)
        }
    }
}
