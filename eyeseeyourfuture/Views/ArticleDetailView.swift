import SwiftUI
import Combine

// MARK: - Article Detail View
struct ArticleDetailView: View {
    let article: ReadingArticle
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager
    @Environment(\.dismiss) private var dismiss

    @AppStorage("isPremium") var isPremium = false
    @State private var showSubscription = false
    @EnvironmentObject var globalLm: LocalizationManager // Renamed to avoid name collision with Observables if any

    var body: some View {
        ZStack(alignment: .top) {
            themeManager.bgColor.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Hero Image Section
                        ZStack(alignment: .bottom) {
                            ArticleHeroImage(imageName: article.imageName, category: article.category)
                                .frame(height: 300)
                                .clipped()
                            
                            // Gradient overlay
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, themeManager.bgColor]),
                                startPoint: .center,
                                endPoint: .bottom
                            )
                            .frame(height: 200)
                            
                            // Floating back button
                            VStack {
                                HStack {
                                    Button(action: { dismiss() }) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(Color.black.opacity(0.4))
                                            .clipShape(Circle())
                                    }
                                    .padding(.leading, 16)
                                    .padding(.top, 56)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .frame(height: 300)
                        }
                        
                        // Content area
                        VStack(alignment: .leading, spacing: 20) {
                            // Category badge + read time
                            HStack(spacing: 12) {
                                Label(article.category.rawValue, systemImage: article.category.icon)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(themeManager.bgColor)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(themeManager.accentYellow)
                                    .cornerRadius(20)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 11))
                                    Text("\(article.readingMinutes) \(lm.t(.readingMinutes))")
                                        .font(.system(size: 11))
                                }
                                .foregroundColor(themeManager.secondaryTextColor)
                            }
                            
                            // Title
                            Text(article.title)
                                .font(.system(size: 26, weight: .bold, design: .serif))
                                .foregroundColor(themeManager.primaryTextColor)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Subtitle / lead
                            Text(article.subtitle.uppercased())
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundColor(themeManager.accentYellow.opacity(0.8))
                            
                            // Divider line
                            Rectangle()
                                .fill(themeManager.accentYellow.opacity(0.25))
                                .frame(height: 1)
                            
                            // Summary lead paragraph
                            Text(article.summary)
                                .font(.system(size: 15, design: .serif))
                                .italic()
                                .foregroundColor(themeManager.secondaryTextColor)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                                .blur(radius: isPremium ? 0 : 4)
                            
                            // Article body — rendered as styled paragraphs
                            ArticleBodyText(content: article.content, themeManager: themeManager)
                                .blur(radius: isPremium ? 0 : 12)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, -24)
                        .padding(.bottom, 60)
                    }
                }
                
                AdBannerView()
            }
            
            if !isPremium {
                PremiumLockOverlay(onSubscribe: {
                    showSubscription = true
                })
            }
        }
        .navigationBarHidden(true)
        .statusBar(hidden: false)
        .sheet(isPresented: $showSubscription) {
            SubscriptionView(shouldShowPersonalSetup: .constant(false))
                .environmentObject(themeManager)
                .environmentObject(lm)
        }
    }
}

// MARK: - Article Body Text (renders **bold** markdown)
struct ArticleBodyText: View {
    let content: String
    @ObservedObject var themeManager: ThemeManager

    private var paragraphs: [String] {
        content.components(separatedBy: "\n\n").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, para in
                if para.hasPrefix("**") && para.hasSuffix("**") {
                    // Section heading
                    Text(para.replacingOccurrences(of: "**", with: ""))
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.accentYellow)
                } else {
                    Text(LocalizedStringKey(para))
                        .font(.system(size: 15))
                        .foregroundColor(themeManager.primaryTextColor.opacity(0.85))
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

// MARK: - Article Hero Image (gradient-based placeholder)
struct ArticleHeroImage: View {
    let imageName: String
    let category: ReadingCategory

    private var gradientColors: [Color] {
        switch category {
        case .meditation:
            return [Color(hex: "#1a0533"), Color(hex: "#3d1a6e"), Color(hex: "#221e10")]
        case .personality:
            return [Color(hex: "#0d1b3e"), Color(hex: "#1a3a6e"), Color(hex: "#221e10")]
        case .development:
            return [Color(hex: "#0f2119"), Color(hex: "#1a4a2e"), Color(hex: "#221e10")]
        case .mindfulness:
            return [Color(hex: "#1a2a0d"), Color(hex: "#2d4a1a"), Color(hex: "#221e10")]
        case .wellness:
            return [Color(hex: "#3d0d0d"), Color(hex: "#6e1a1a"), Color(hex: "#221e10")]
        case .spiritualism:
            return [Color(hex: "#1a0b2e"), Color(hex: "#2e1a4d"), Color(hex: "#221e10")]
        case .astrology:
            return [Color(hex: "#0b1a2e"), Color(hex: "#1a3d6e"), Color(hex: "#221e10")]
        case .all:
            return [Color(hex: "#221e10"), Color(hex: "#3d3510"), Color(hex: "#221e10")]
        }
    }

    private var symbolName: String {
        switch category {
        case .meditation:   return "figure.mind.and.body"
        case .personality:  return "brain.head.profile"
        case .development:  return "chart.line.uptrend.xyaxis"
        case .mindfulness:  return "leaf.fill"
        case .wellness:     return "heart.fill"
        case .spiritualism: return "moon.stars.fill"
        case .astrology:    return "sparkles.rectangle.stack"
        case .all:          return "star.fill"
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Decorative background pattern (Dots)
                CirclePattern(color: Color.white.opacity(0.05))
                    .offset(x: -50, y: -50)
                
                // Core Glow - Scaled to geometry
                RadialGradient(
                    gradient: Gradient(colors: [themeColor.opacity(0.4), .clear]),
                    center: .center,
                    startRadius: 0,
                    endRadius: geometry.size.width * 0.6
                )
                .frame(width: geometry.size.width, height: geometry.size.width)
                .offset(x: geometry.size.width * 0.2, y: -geometry.size.width * 0.1)

                // Secondary Glow
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.15), .clear]),
                            center: .center,
                            startRadius: 0,
                            endRadius: geometry.size.width * 0.3
                        )
                    )
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6)
                    .offset(x: -geometry.size.width * 0.3, y: geometry.size.width * 0.3)
                    .blur(radius: 40)

                // Large Decorative Symbol (Blurred Background)
                Image(systemName: symbolName)
                    .font(.system(size: geometry.size.width * 0.45, weight: .light))
                    .foregroundColor(themeColor.opacity(0.1))
                    .rotationEffect(.degrees(-15))
                    .offset(x: -geometry.size.width * 0.2, y: geometry.size.width * 0.05)
                    .blur(radius: 2)

                // Main Category Symbol
                Image(systemName: symbolName)
                    .font(.system(size: geometry.size.width * 0.3, weight: .thin))
                    .foregroundColor(themeColor.opacity(0.4))
                    .rotationEffect(.degrees(12))
                    .offset(x: geometry.size.width * 0.2, y: -geometry.size.width * 0.05)
                    .shadow(color: themeColor.opacity(0.5), radius: 20, x: 0, y: 10)

                // Dynamic category-specific accents
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        CategoryAccent(category: category, color: themeColor)
                    }
                }
                .padding(geometry.size.width * 0.08)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped() // CRITICAL: Prevent overflow
        }
        .frame(maxWidth: .infinity)
        .overlay(
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, Color.black.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
    }
    
    private var themeColor: Color {
        Color(hex: "#f4c025")
    }
}

// MARK: - Decorative Accent Components
struct CirclePattern: View {
    let color: Color
    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<6) { _ in
                HStack(spacing: 20) {
                    ForEach(0..<6) { _ in
                        Circle()
                            .fill(color)
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
    }
}

struct CategoryAccent: View {
    let category: ReadingCategory
    let color: Color
    
    var body: some View {
        Group {
            switch category {
            case .astrology:
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 24))
            case .personality:
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 24))
            case .meditation:
                Image(systemName: "figure.mind.and.body")
                    .font(.system(size: 24))
            default:
                Image(systemName: "sparkles")
                    .font(.system(size: 24))
            }
        }
        .foregroundColor(color.opacity(0.3))
    }
}
