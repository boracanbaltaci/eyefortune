import SwiftUI

// MARK: - Reading View
struct ReadingView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    @StateObject private var viewModel = ReadingViewModel()
    @State private var selectedArticle: ReadingArticle? = nil

    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        // MARK: Featured Banner
                        if let featured = viewModel.featuredArticle {
                            FeaturedReadingBanner(article: featured, themeManager: themeManager, lm: lm) {
                                selectedArticle = featured
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        }

                        // MARK: Category Filter Tabs
                        CategoryFilterRow(
                            selected: $viewModel.selectedCategory,
                            themeManager: themeManager,
                            lm: lm
                        )
                        .padding(.top, 20)

                        // MARK: Article Cards
                        if viewModel.nonFeaturedFiltered.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "book.closed")
                                    .font(.system(size: 40))
                                    .foregroundColor(themeManager.accentYellow.opacity(0.3))
                                Text(lm.t(.readingEmpty))
                                    .font(.system(size: 14, design: .serif))
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.nonFeaturedFiltered) { article in
                                    ReadingArticleCard(article: article, themeManager: themeManager, lm: lm) {
                                        selectedArticle = article
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        }

                        Spacer().frame(height: 60)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(lm.t(.readingTitle))
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                }
            }
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(item: $selectedArticle) { article in
                ArticleDetailView(article: article, themeManager: themeManager, lm: lm)
            }
        }
    }
}

// MARK: - Featured Reading Banner
struct FeaturedReadingBanner: View {
    let article: ReadingArticle
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                // Background gradient hero
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#2a1f08"),
                                themeManager.accentYellow.opacity(0.25)
                            ]),
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                    )
                    .frame(height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(themeManager.accentYellow.opacity(0.3), lineWidth: 1)
                    )

                // Decorative large symbol
                Image(systemName: article.category.icon)
                    .font(.system(size: 120, weight: .thin))
                    .foregroundColor(themeManager.accentYellow.opacity(0.1))
                    .rotationEffect(.degrees(15))
                    .offset(x: 180, y: -20)
                    .clipped()

                // Sparkle decorations
                Image(systemName: "sparkles")
                    .font(.system(size: 28))
                    .foregroundColor(themeManager.accentYellow.opacity(0.25))
                    .offset(x: 240, y: -120)

                // Text content
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(lm.t(.readingFeatured)) · \(lm.t(.readingToday))")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(2)
                        .foregroundColor(themeManager.accentYellow)

                    Text(article.title)
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 12) {
                        Label(article.category.rawValue, systemImage: article.category.icon)
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.7))

                        Label("\(article.readingMinutes) dk", systemImage: "clock")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    HStack {
                        Text(lm.t(.readingBegin))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(themeManager.bgColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(themeManager.accentYellow)
                            .cornerRadius(20)
                    }
                    .padding(.top, 4)
                }
                .padding(20)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Category Filter Row
struct CategoryFilterRow: View {
    @Binding var selected: ReadingCategory
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ReadingCategory.allCases) { category in
                    CategoryCard(
                        category: category,
                        isSelected: selected == category,
                        themeManager: themeManager,
                        lm: lm
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selected = category
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }
}

struct CategoryCard: View {
    let category: ReadingCategory
    let isSelected: Bool
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager
    let onTap: () -> Void

    private var localizedName: String {
        switch category {
        case .all:         return lm.t(.readingCatAll)
        case .meditation:  return lm.t(.readingCatMed)
        case .personality: return lm.t(.readingCatPers)
        case .development: return lm.t(.readingCatDev)
        case .mindfulness: return lm.t(.readingCatMind)
        case .wellness:    return lm.t(.readingCatWell)
        case .spiritualism: return lm.t(.readingCatSpir)
        case .astrology:    return lm.t(.readingCatAstro)
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? themeManager.bgColor : themeManager.accentYellow)
                
                Text(localizedName)
                    .font(.system(size: 14, weight: .bold, design: .serif))
                    .foregroundColor(isSelected ? themeManager.bgColor : themeManager.primaryTextColor)
            }
            .frame(width: 100, height: 100, alignment: .bottomLeading)
            .padding(12)
            .background(
                isSelected
                    ? themeManager.accentYellow
                    : themeManager.cardBgColor
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? themeManager.accentYellow : themeManager.accentYellow.opacity(0.15),
                        lineWidth: 1
                    )
            )
            .shadow(color: isSelected ? themeManager.accentYellow.opacity(0.3) : Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Reading Article Card
struct ReadingArticleCard: View {
    let article: ReadingArticle
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var lm: LocalizationManager
    let onTap: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image Area
                ZStack(alignment: .bottomLeading) {
                    ArticleHeroImage(imageName: article.imageName, category: article.category)
                        .frame(height: 180)
                        .clipShape(
                            RoundedCornerShape(corners: [.topLeft, .topRight], radius: 16)
                        )

                    // Gradient fade into card
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, themeManager.cardBgColor.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    .clipShape(
                        RoundedCornerShape(corners: [.topLeft, .topRight], radius: 16)
                    )

                    // Category badge on image
                    Label(article.category.rawValue, systemImage: article.category.icon)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(themeManager.bgColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(themeManager.accentYellow)
                        .cornerRadius(20)
                        .padding(12)
                }

                // Card body
                VStack(alignment: .leading, spacing: 10) {
                    Text(article.title)
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(article.summary)
                        .font(.system(size: 13))
                        .foregroundColor(themeManager.secondaryTextColor)
                        .lineLimit(3)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 11))
                            Text("\(article.readingMinutes) \(lm.t(.readingMinutes))")
                                .font(.system(size: 11))
                        }
                        .foregroundColor(themeManager.secondaryTextColor.opacity(0.7))

                        Spacer()

                        HStack(spacing: 4) {
                            Text(lm.t(.readingBegin))
                                .font(.system(size: 12, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 11, weight: .bold))
                        }
                        .foregroundColor(themeManager.accentYellow)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(themeManager.accentYellow.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(themeManager.accentYellow.opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(10)
                    }
                }
                .padding(16)
            }
            .background(themeManager.cardBgColor)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(themeManager.accentYellow.opacity(0.12), lineWidth: 1)
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isHovered ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isHovered)
    }
}

// MARK: - Rounded corner helper shape
struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ReadingView()
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
