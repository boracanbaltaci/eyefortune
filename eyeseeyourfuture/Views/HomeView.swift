import SwiftUI

// MARK: - Insight Category Model
struct InsightCategory: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let description: String
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
        InsightCategory(title: "Aşk & İlişkiler", subtitle: "Uyum: Yüksek Potansiyel", icon: "heart.fill", color: Color.pink, description: "Kalbinin derinliklerinde saklı olan duygular, bu dönemde gün yüzüne çıkacak. Partnerinle olan iletişimin güçleniyor, ancak küçük yanlış anlaşılmalara karşı dikkatli olmalısın."),
        InsightCategory(title: "Canlılık & Sağlık", subtitle: "Enerji: Ay Fazına Duyarlı", icon: "bolt.fill", color: Color.green, description: "Fiziksel enerjin şu sıralar dalgalı seyredebilir. Dinlenmeye ve meditasyona vakit ayırarak iç dengeni korumaya odaklanmalısın. Doğal taşların enerjisinden faydalanabilirsin."),
        InsightCategory(title: "Refah & Bolluk", subtitle: "Durum: Yükselen Şans", icon: "dollarsign.circle.fill", color: Color(hex: "#f4c025"), description: "Maddi konularda beklenmedik kapılar aralanabilir. Harcamalarını kontrol altında tutarsan, ay sonuna doğru bütçende gözle görülür bir rahatlama hissedebilirsin."),
        InsightCategory(title: "Kariyer & Hedefler", subtitle: "Yol: Geçiş Evresi", icon: "briefcase.fill", color: Color.blue, description: "İş hayatında yeni sorumluluklar seni bekliyor olabilir. Yeteneklerini sergilemek için harika bir fırsat dönemi. Cesur adımlar atmaktan çekinme, yıldızlar seni destekliyor.")
    ]
    
    @State private var showSettings = false
    @State private var showFortunePage = false
    @State private var personalityAnalysisText: String = ""
    @State private var showPersonalityModal = false
    
    @State private var showInsightModal = false
    @State private var selectedInsightType: InsightDetailView.InsightType = .strengths
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // MARK: Eye / Profile Section
                        VStack(spacing: 0) {
                            ZStack {
                                Circle()
                                    .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
                                    .frame(width: 280, height: 280)
                                
                                Circle()
                                    .fill(RadialGradient(
                                        gradient: Gradient(colors: [themeManager.accentYellow.opacity(0.15), Color.clear]),
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 140
                                    ))
                                    .frame(width: 280, height: 280)
                                
                                ZStack {
                                    Circle()
                                        .fill(themeManager.cardBgColor)
                                        .frame(width: 144, height: 144)
                                    
                                    Circle()
                                        .stroke(themeManager.accentYellow, lineWidth: 2.5)
                                        .frame(width: 144, height: 144)
                                        .shadow(color: themeManager.accentYellow.opacity(0.4), radius: 20)
                                    
                                    if !scannedEyeImagePath.isEmpty,
                                       let uiImage = UIImage(contentsOfFile: scannedEyeImagePath) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 134, height: 134)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "eye.fill")
                                            .font(.system(size: 55))
                                            .foregroundColor(themeManager.accentYellow.opacity(0.6))
                                    }
                                }
                            }
                            .padding(.top, 10)
                            
                            VStack(spacing: 8) {
                                Text(dynamicGreeting)
                                    .font(.system(size: 13, weight: .black))
                                    .tracking(3)
                                    .foregroundColor(themeManager.accentYellow.opacity(0.8))
                                
                                Text(userName.isEmpty ? "Oracle Seer" : userName)
                                    .font(.system(size: 32, weight: .bold, design: .serif))
                                    .foregroundColor(themeManager.accentYellow)
                                
                                Rectangle()
                                    .fill(themeManager.accentYellow.opacity(0.3))
                                    .frame(width: 48, height: 1)
                                
                                Text(mysticSentence)
                                    .font(.system(size: 12, weight: .medium, design: .serif))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .italic()
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 16)
                        }
                        
                        // MARK: Strengths / Weaknesses Buttons
                        HStack(spacing: 12) {
                            Button(action: {
                                selectedInsightType = .strengths
                                showInsightModal = true
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.green)
                                    Text(lm.t(.homeStrengths))
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(themeManager.primaryTextColor)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(themeManager.cardBgColor)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.green.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            Button(action: {
                                selectedInsightType = .weaknesses
                                showInsightModal = true
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "shield.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.red)
                                    Text(lm.t(.homeWeaknesses))
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(themeManager.primaryTextColor)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(themeManager.cardBgColor)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red.opacity(0.15), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // MARK: CTA Buttons
                        VStack(spacing: 16) {
                            Button(action: {
                                showFortunePage = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 20, weight: .bold))
                                    Text(lm.t(.homeDailyFortune))
                                        .font(.system(size: 16, weight: .black))
                                        .tracking(2)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: themeManager.activeTheme == .aurora 
                                                           ? [Color(hex: "#5D4037"), Color(hex: "#8B4513")] 
                                                           : [Color(hex: "#f4c025"), Color(hex: "#ffd700")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(18)
                                .shadow(color: (themeManager.activeTheme == .aurora ? Color(hex: "#8B4513") : themeManager.accentYellow).opacity(0.35), radius: 12, x: 0, y: 6)
                            }
                            
                            Button(action: {
                                personalityAnalysisText = "Yıldızların konumuna ve ruhsal frekansına göre yapılan derin analiz sonuçların hazır. İçsel dengen şu sıralar toprak elementinin ağırlığı altında, bu da senin için sağlam kararlar alma dönemine işaret ediyor. Kariyerinde sabırlı olman gereken bir evredesin, meyvelerini yakında toplayacaksın. İlişkilerinde ise daha şeffaf olman gereken bir dönem. Kendine olan güvenin arttıkça etrafındaki aura da parlayacak. Unutma, evren senin niyetine göre şekillenir."
                                showPersonalityModal = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "brain.head.profile")
                                        .font(.system(size: 20, weight: .bold))
                                    Text(lm.t(.homePersonality))
                                        .font(.system(size: 16, weight: .black))
                                        .tracking(2)
                                }
                                .foregroundColor(themeManager.accentYellow)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(themeManager.cardBgColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(themeManager.accentYellow.opacity(0.4), lineWidth: 2)
                                )
                                .cornerRadius(18)
                                .shadow(color: themeManager.accentYellow.opacity(0.1), radius: 10, x: 0, y: 5)
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
                ToolbarItem(placement: .principal) {
                    Text("Oracle Profile")
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(themeManager.primaryTextColor)
                    }
                }
            }
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showFortunePage) {
                if let fortune = fortuneViewModel.dailyFortune {
                    FortuneResultView(fortune: fortune)
                } else {
                    FortuneResultView(fortune: Fortune(text: "Yıldızlar şu an fısıldıyor... Birazdan hazır olacak.", dateGenerated: Date(), type: .daily))
                }
            }
            .sheet(isPresented: $showPersonalityModal) {
                FortuneResultView(fortune: Fortune(text: personalityAnalysisText, dateGenerated: Date(), type: .aiScan))
            }
            .sheet(isPresented: $showInsightModal) {
                InsightDetailView(type: selectedInsightType)
            }
        }
    }
    
    private var dynamicGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "GÜNAYDIN"
        case 12..<18: return "İYİ GÜNLER"
        case 18..<22: return "İYİ AKŞAMLAR"
        default: return "İYİ GECELER"
        }
    }
    
    private var mysticSentence: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Güneşin doğuşuyla evrenin kapıları aralanıyor, ruhun ışığa kavuşuyor."
        case 12..<18: return "Günün en parlak anında kadim bilgiler zihnine akmaya başlıyor."
        case 18..<22: return "Yıldızlar gökyüzüne yerleşirken gizemli mesajlar sezgilerine ulaşıyor."
        default: return "Gecenin derinliğinde yıldızlar parlıyor, sana rehberlik eden mesajlar fısıldıyorlar."
        }
    }
}

// MARK: - Subviews
struct AnalysisButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 13, weight: .bold))
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(color.opacity(0.05))
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.2), lineWidth: 1))
        }
    }
}

struct MainActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let themeManager: ThemeManager
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle().fill(themeManager.accentYellow.opacity(0.1)).frame(width: 44, height: 44)
                    Image(systemName: icon).foregroundColor(themeManager.accentYellow)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 14)).foregroundColor(themeManager.secondaryTextColor.opacity(0.3))
            }
            .padding(15)
            .background(themeManager.cardBgColor)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(themeManager.accentYellow.opacity(0.1), lineWidth: 1))
        }
    }
}

struct InsightBox: View {
    let title: String
    let info: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon).foregroundColor(color).font(.system(size: 14))
                Text(title).font(.system(size: 10, weight: .black)).foregroundColor(color).tracking(1)
            }
            Text(info)
                .font(.system(size: 12, weight: .medium, design: .serif))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(white: 1, opacity: 0.03))
        .cornerRadius(14)
    }
}

struct AnalysisDetailView: View {
    let title: String
    let text: String
    let themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(text)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(themeManager.primaryTextColor)
                        
                        Spacer()
                    }
                    .padding(30)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") { dismiss() }.foregroundColor(themeManager.accentYellow)
                }
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
            if isExpanded {
                VStack(spacing: 0) {
                    Divider()
                        .background(themeManager.secondaryTextColor.opacity(0.1))
                    
                    VStack(spacing: 12) {
                        Text(category.description)
                            .font(.system(size: 14, weight: .medium, design: .serif))
                            .foregroundColor(themeManager.primaryTextColor)
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
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
