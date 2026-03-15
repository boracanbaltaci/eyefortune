import SwiftUI
import WidgetKit

struct WidgetThemeTestView: View {
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager
    
    // Shared UserDefaults for App Groups
    private let sharedDefaults = UserDefaults(suiteName: "group.com.boradev.eyefortune") ?? .standard
    
    @State private var widgetOverrideIndex: Int = -1
    
    var body: some View {
        ZStack {
            themeManager.bgColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    Text("Widget Görünüm Testi")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                        .padding(.top, 20)
                    
                    Text("Aşağıdaki temalardan birini seçerek widget'ın nasıl görüneceğini test edebilirsiniz. Seçtiğiniz an widget güncellenecektir.")
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        Button(action: { updateSelection(-1) }) {
                            HStack {
                                Text("Otomatik (Günün Teması)")
                                Spacer()
                                if widgetOverrideIndex == -1 {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(themeManager.accentYellow)
                                }
                            }
                            .padding()
                            .background(themeManager.cardBgColor)
                            .cornerRadius(12)
                        }
                        .foregroundColor(themeManager.primaryTextColor)
                        
                        Divider().padding(.vertical, 8)
                        
                        ForEach(0..<DailyThemeManager.shared.allThemes.count, id: \.self) { index in
                            let theme = DailyThemeManager.shared.theme(at: index)
                            Button(action: { updateSelection(index) }) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(theme.color.opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: theme.symbol)
                                            .foregroundColor(theme.color)
                                    }
                                    
                                    Text(lm.t(theme.nameKey))
                                    
                                    Spacer()
                                    
                                    if widgetOverrideIndex == index {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(themeManager.accentYellow)
                                    }
                                }
                                .padding()
                                .background(themeManager.cardBgColor)
                                .cornerRadius(12)
                            }
                            .foregroundColor(themeManager.primaryTextColor)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            widgetOverrideIndex = sharedDefaults.integer(forKey: "widgetOverrideIndex")
            if sharedDefaults.object(forKey: "widgetOverrideIndex") == nil {
                widgetOverrideIndex = -1
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func updateSelection(_ index: Int) {
        widgetOverrideIndex = index
        sharedDefaults.set(index, forKey: "widgetOverrideIndex")
        
        // Trigger widget reload
        WidgetCenter.shared.reloadAllTimelines()
    }
}
