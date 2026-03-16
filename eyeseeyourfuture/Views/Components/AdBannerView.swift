import SwiftUI

struct AdBannerView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    @AppStorage("isPremium") var isPremium = false

    var body: some View {
        if !isPremium {
            VStack(spacing: 0) {
                Divider()
                    .background(themeManager.accentYellow.opacity(0.1))
                
                HStack(spacing: 12) {
                    // Ad Icon/Placeholder
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(themeManager.accentYellow.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "sparkles.rectangle.stack.fill")
                            .foregroundColor(themeManager.accentYellow)
                            .font(.system(size: 18))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("SPONSORED AD")
                            .font(.system(size: 9, weight: .black))
                            .tracking(1)
                            .foregroundColor(themeManager.accentYellow.opacity(0.6))
                        
                        Text("Get Premium for an Ad-Free Experience")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(themeManager.primaryTextColor.opacity(0.9))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(themeManager.accentYellow.opacity(0.4))
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(.horizontal, 16)
                .frame(height: 64)
                .background(themeManager.cardBgColor)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}
