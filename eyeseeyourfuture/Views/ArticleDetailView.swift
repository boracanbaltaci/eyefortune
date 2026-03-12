import SwiftUI
import Combine

// MARK: - Article Detail View
struct ArticleDetailView: View {
    let article: ReadingArticle
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager
    @Environment(\.dismiss) private var dismiss

    @State private var scrollOffset: CGFloat = 0
    @State private var headerOpacity: Double = 0

    var body: some View {
        ZStack(alignment: .top) {
            themeManager.bgColor.ignoresSafeArea()

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

                        // Article body — rendered as styled paragraphs
                        ArticleBodyText(content: article.content, themeManager: themeManager)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, -24)
                    .padding(.bottom, 60)
                }
            }
        }
        .navigationBarHidden(true)
        .statusBar(hidden: false)
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
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Decorative radial glow
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [Color(hex: "#f4c025").opacity(0.25), .clear]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 160
                    )
                )
                .frame(width: 320, height: 320)
                .offset(x: 40, y: -30)

            // Large symbol
            Image(systemName: symbolName)
                .font(.system(size: 100, weight: .thin))
                .foregroundColor(Color(hex: "#f4c025").opacity(0.15))
                .rotationEffect(.degrees(12))
                .offset(x: 60, y: 20)

            // Smaller decorative sparkles
            Image(systemName: "sparkles")
                .font(.system(size: 30, weight: .thin))
                .foregroundColor(Color(hex: "#f4c025").opacity(0.3))
                .offset(x: -80, y: -60)
        }
        .frame(maxWidth: .infinity)
    }
}
