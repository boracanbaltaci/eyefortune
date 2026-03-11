import SwiftUI

// MARK: - Insight Category Model
struct InsightCategory: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let extraInfo: [(String, String)]?  // (label, value) pairs for expanded view
    var isExpanded: Bool = false
}

// MARK: - HomeView
struct HomeView: View {
    @EnvironmentObject var fortuneViewModel: FortuneViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
    
    @AppStorage("scannedEyeImagePath") var scannedEyeImagePath: String = ""
    @AppStorage("userName") var userName: String = "Oracle Seer"
    
    @State private var categories: [InsightCategory] = [
        InsightCategory(title: "Love & Connections", subtitle: "Harmony: High Alignment", icon: "heart.fill", color: Color.pink, extraInfo: nil),
        InsightCategory(title: "Vitality & Health", subtitle: "Energy: Moon Phase Sensitive", icon: "cross.fill", color: Color.green, extraInfo: nil),
        InsightCategory(title: "Wealth & Abundance", subtitle: "Status: Rising Fortune", icon: "dollarsign.circle.fill", color: Color(hex: "#f4c025"), extraInfo: [("Luck Index", "8.4"), ("Manifesting", "Strong")]),
        InsightCategory(title: "Career & Purpose", subtitle: "Path: Transitional Phase", icon: "briefcase.fill", color: Color.blue, extraInfo: nil)
    ]
    
    @State private var showFortunePage = false
    @State private var showPersonalityAnalysis = false
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // MARK: Eye / Profile Section
                        VStack(spacing: 0) {
                            // Circular Eye Image with outer ring
                            ZStack {
                                // Outer decorative ring
                                Circle()
                                    .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
                                    .frame(width: 280, height: 280)
                                
                                // Inner glow
                                Circle()
                                    .fill(RadialGradient(
                                        gradient: Gradient(colors: [themeManager.accentYellow.opacity(0.15), Color.clear]),
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 140
                                    ))
                                    .frame(width: 280, height: 280)
                                
                                // Eye image circle
                                ZStack {
                                    Circle()
                                        .fill(themeManager.cardBgColor)
                                        .frame(width: 144, height: 144)
                                    
                                    Circle()
                                        .stroke(themeManager.accentYellow, lineWidth: 2.5)
                                        .frame(width: 144, height: 144)
                                        .shadow(color: themeManager.accentYellow.opacity(0.4), radius: 20)
                                    
                                    // Scanned Eye or placeholder
                                    if !scannedEyeImagePath.isEmpty,
                                       let uiImage = UIImage(contentsOfFile: scannedEyeImagePath) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 134, height: 134)
                                            .clipShape(Circle())
                                    } else {
                                        // Placeholder if no eye scan
                                        Image(systemName: "eye.fill")
                                            .font(.system(size: 55))
                                            .foregroundColor(themeManager.accentYellow.opacity(0.6))
                                    }
                                }
                            }
                            .padding(.top, 30)
                            
                            // Name + Tier
                            VStack(spacing: 8) {
                                Text(userName.isEmpty ? "Oracle Seer" : userName)
                                    .font(.system(size: 30, weight: .bold, design: .serif))
                                    .foregroundColor(themeManager.accentYellow)
                                
                                Rectangle()
                                    .fill(themeManager.accentYellow.opacity(0.3))
                                    .frame(width: 48, height: 1)
                                
                            Text("TIER IV MYSTIC")
                                    .font(.system(size: 11, weight: .bold))
                                    .tracking(3)
                                    .foregroundColor(themeManager.accentYellow.opacity(0.8))
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 24)
                        }
                        
                        // MARK: Strengths / Weaknesses Buttons
                        HStack(spacing: 12) {
                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 14))
                                    Text(lm.t(.homeStrengths))
                                        .font(.system(size: 14, weight: .bold, design: .serif))
                                }
                                .foregroundColor(themeManager.accentYellow)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(themeManager.accentYellow.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(themeManager.accentYellow.opacity(0.3), lineWidth: 1)
                                )
                                .cornerRadius(14)
                            }
                            
                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Image(systemName: "exclamationmark.circle")
                                        .font(.system(size: 14))
                                    Text(lm.t(.homeWeaknesses))
                                        .font(.system(size: 14, weight: .bold, design: .serif))
                                }
                                .foregroundColor(themeManager.secondaryTextColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(themeManager.accentYellow.opacity(0.04))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(themeManager.secondaryTextColor.opacity(0.15), lineWidth: 1)
                                )
                                .cornerRadius(14)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // MARK: CTA Buttons
                        VStack(spacing: 12) {
                            // Daily Fortune Button - Golden gradient
                            Button(action: {
                                showFortunePage = true
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 18, weight: .bold))
                                    Text(lm.t(.homeDailyFortune))
                                        .font(.system(size: 15, weight: .black))
                                        .tracking(2)
                                }
                                .foregroundColor(themeManager.bgColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#f4c025"), Color(hex: "#ffd700"), Color(hex: "#f4c025")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(14)
                                .shadow(color: themeManager.accentYellow.opacity(0.4), radius: 15, x: 0, y: 5)
                            }
                            
                            // Personality Analysis Button
                            Button(action: {
                                showPersonalityAnalysis = true
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "brain.head.profile")
                                        .font(.system(size: 18, weight: .bold))
                                    Text(lm.t(.homePersonality))
                                        .font(.system(size: 15, weight: .black))
                                        .tracking(2)
                                }
                                .foregroundColor(themeManager.accentYellow)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(themeManager.accentYellow.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(themeManager.accentYellow.opacity(0.5), lineWidth: 1.5)
                                )
                                .cornerRadius(14)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        
                        // MARK: Insight Categories
                        VStack(spacing: 12) {
                            ForEach(Array(categories.enumerated()), id: \.element.id) { index, category in
                                InsightCategoryCard(
                                    category: category,
                                    isExpanded: category.isExpanded,
                                    themeManager: themeManager,
                                    onToggle: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            categories[index].isExpanded.toggle()
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 60)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(themeManager.primaryTextColor)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Oracle Profile")
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                            .foregroundColor(themeManager.primaryTextColor)
                    }
                }
            }
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

// MARK: - Insight Category Card
struct InsightCategoryCard: View {
    let category: InsightCategory
    let isExpanded: Bool
    @ObservedObject var themeManager: ThemeManager
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Row
            Button(action: onToggle) {
                HStack(spacing: 16) {
                    // Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(category.color.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: category.icon)
                            .foregroundColor(category.color)
                            .font(.system(size: 16))
                    }
                    
                    // Text
                    VStack(alignment: .leading, spacing: 2) {
                        Text(category.title)
                            .font(.system(size: 15, weight: .bold, design: .serif))
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Text(category.subtitle)
                            .font(.system(size: 11))
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    
                    Spacer()
                    
                    // Expand chevron
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(isExpanded ? themeManager.accentYellow : themeManager.secondaryTextColor.opacity(0.4))
                    
                    // See Insights pill button
                    Text("See Insights")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(0.5)
                        .foregroundColor(themeManager.accentYellow)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(themeManager.accentYellow.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
                        )
                        .cornerRadius(8)
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expandable Content
            if isExpanded, let extraInfo = category.extraInfo {
                VStack(spacing: 0) {
                    Divider()
                        .background(themeManager.secondaryTextColor.opacity(0.1))
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            ForEach(extraInfo, id: \.0) { item in
                                VStack(spacing: 4) {
                                    Text(item.0.uppercased())
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    Text(item.1)
                                        .font(.system(size: 18, weight: .bold, design: .serif))
                                        .foregroundColor(themeManager.accentYellow)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(themeManager.inputBgColor)
                                .cornerRadius(10)
                            }
                        }
                        
                        Text("\"Financial winds blow from the east this week. Prepare for a surprise bounty.\"")
                            .font(.system(size: 12, design: .serif))
                            .italic()
                            .foregroundColor(themeManager.secondaryTextColor)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(themeManager.cardBgColor)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isExpanded ? themeManager.accentYellow.opacity(0.4) : themeManager.accentYellow.opacity(0.1), lineWidth: isExpanded ? 1.5 : 1)
        )
        .cornerRadius(14)
        .shadow(color: isExpanded ? themeManager.accentYellow.opacity(0.05) : .clear, radius: 10)
    }
}

// MARK: - Pulse Effect
struct PulseEffect: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.2 : 1.0)
            .opacity(isPulsing ? 0.5 : 1.0)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

#Preview {
    HomeView()
        .environmentObject(FortuneViewModel())
        .environmentObject(ThemeManager())
        .environmentObject(LocalizationManager())
}
