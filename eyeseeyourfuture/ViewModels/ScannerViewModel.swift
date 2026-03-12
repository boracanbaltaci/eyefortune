import Foundation
import Combine

class ScannerViewModel: ObservableObject {
    @Published var scanProgress: Double = 0.0
    @Published var isScanning: Bool = false
    @Published var scanComplete: Bool = false
    @Published var generatedFortune: Fortune?
    
    private let aiService = AIService()
    
    func startScan() {
        isScanning = true
        scanProgress = 0.0
        scanComplete = false
        generatedFortune = nil
        
        // Simulate scan progress
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.scanProgress >= 1.0 {
                timer.invalidate()
                self.processScanWithAI()
            } else {
                self.scanProgress += 0.05
            }
        }
    }
    
    private func processScanWithAI() {
        // Send simulated image data to AI service
        aiService.analyzeEyeScan(imageData: Data()) { [weak self] fortune in
            DispatchQueue.main.async {
                self?.isScanning = false
                self?.scanComplete = true
                self?.generatedFortune = fortune
            }
        }
    }
}
