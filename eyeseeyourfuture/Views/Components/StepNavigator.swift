import SwiftUI

struct StepNavigator: View {
    let currentStep: Int
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...3, id: \.self) { step in
                Capsule()
                    .fill(currentStep >= step ? themeManager.accentYellow : themeManager.accentYellow.opacity(0.15))
                    .frame(width: 40, height: 6)
                    .shadow(color: currentStep == step ? themeManager.accentYellow.opacity(0.3) : .clear, radius: 4)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}
