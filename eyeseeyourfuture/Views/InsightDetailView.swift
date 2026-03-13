import SwiftUI

struct InsightDetailView: View {
    let type: InsightType
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    enum InsightType: String, Identifiable {
        case strengths
        case weaknesses
        
        var id: String { rawValue }
        
        var title: String {
            self == .strengths ? "Güçlü Yönlerin" : "Zayıf Yönlerin"
        }
        
        var icon: String {
            self == .strengths ? "star.circle.fill" : "shield.exclamationmark.fill"
        }
        
        var mainColor: Color {
            self == .strengths ? .green : .red
        }
    }
    
    var body: some View {
        ZStack {
            themeManager.bgColor.ignoresSafeArea()
            
            // Decorative backgrounds based on type
            ZStack {
                if type == .strengths {
                    // Vibrant, energetic aura
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.green.opacity(0.15), .yellow.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 400, height: 400)
                        .blur(radius: 60)
                        .offset(y: -100)
                } else {
                    // Deep, serious atmospheric glow
                    RadialGradient(
                        gradient: Gradient(colors: [Color.red.opacity(0.12), .clear]),
                        center: .top,
                        startRadius: 0,
                        endRadius: 500
                    )
                    .frame(height: 500)
                    .ignoresSafeArea()
                }
            }
            
            VStack(spacing: 0) {
                // Custom Header (Matching FortuneResultView)
                HStack {
                    Color.clear.frame(width: 44, height: 44)
                    
                    Spacer()
                    
                    Text(type.title)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.accentYellow)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        ZStack {
                            Circle()
                                .fill(themeManager.cardBgColor)
                                .frame(width: 44, height: 44)
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                            
                            Image(systemName: "xmark")
                                .foregroundColor(themeManager.primaryTextColor)
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .zIndex(10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Premium Header Icon
                        ZStack {
                            Circle()
                                .stroke(type.mainColor.opacity(0.15), lineWidth: 1.5)
                                .frame(width: 150, height: 150)
                            
                            Circle()
                                .fill(type.mainColor.opacity(0.08))
                                .frame(width: 130, height: 130)
                            
                            Image(systemName: type.icon)
                                .font(.system(size: 64))
                                .foregroundColor(type.mainColor)
                                .shadow(color: type.mainColor.opacity(0.5), radius: 20)
                            
                            if type == .strengths {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 24))
                                    .foregroundColor(type.mainColor.opacity(0.6))
                                    .offset(x: 45, y: -45)
                            } else {
                                Image(systemName: "shield.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(type.mainColor.opacity(0.4))
                                    .offset(x: 45, y: -45)
                            }
                        }
                        .padding(.top, 40)
                        
                        // Content Card
                        VStack(alignment: .leading, spacing: 28) {
                            HStack {
                                Text(type == .strengths ? "GÜÇLÜ YÖNLER" : "ZAYIF YÖNLER")
                                    .font(.system(size: 13, weight: .black))
                                    .tracking(3)
                                    .foregroundColor(type.mainColor)
                                Spacer()
                                Capsule()
                                    .fill(type.mainColor.opacity(0.1))
                                    .frame(width: 40, height: 4)
                            }
                            
                            Text(insightContent)
                                .font(.system(size: 19, weight: .medium, design: .serif))
                                .lineSpacing(10)
                                .foregroundColor(themeManager.primaryTextColor)
                            
                            // Advice / Guidance Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 8) {
                                    Image(systemName: type == .weaknesses ? "lightbulb.fill" : "star.fill")
                                        .foregroundColor(type.mainColor)
                                        .font(.system(size: 14))
                                    Text("ORAKIL REHBERLİĞİ")
                                        .font(.system(size: 10, weight: .black))
                                        .tracking(1)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }
                                
                                Text(adviceContent)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(themeManager.primaryTextColor)
                                    .padding(20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(type.mainColor.opacity(0.06))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(type.mainColor.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        .padding(32)
                        .background(
                            RoundedRectangle(cornerRadius: 36)
                                .fill(themeManager.cardBgColor)
                                .shadow(color: Color.black.opacity(0.12), radius: 30, x: 0, y: 15)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [type.mainColor.opacity(0.3), .clear, type.mainColor.opacity(0.1)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .padding(.horizontal, 20)
                        
                        // Footer Message
                        HStack(spacing: 12) {
                            Image(systemName: type == .weaknesses ? "info.circle" : "sparkles")
                                .foregroundColor(type.mainColor.opacity(0.6))
                            Text(type == .weaknesses ? "Farkındalık dönüşümün ilk adımıdır." : "Işığını parlatmaya devam et.")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }
    
    private var insightContent: String {
        if type == .strengths {
            return "Ruhsal haritan, derin bir sezgisel güce ve empatik bir auraya sahip olduğunu gösteriyor. İnsanların söyleyemediklerini hissetme yeteneğin, seni çevrendeki karanlıkta bir fener yapıyor. Kararlılığın ve içsel dengen, en fırtınalı anlarda bile seni ayakta tutan en büyük müttefikin."
        } else {
            return "Kozmik enerjin bazen aşırı hassasiyet nedeniyle dağılabiliyor. Başkalarının enerjilerini sünger gibi çekmen, kendi ruhsal merkezinden uzaklaşmana neden olabilir. Kararsızlık anlarında evrenin işaretlerini yanlış yorumlamaya meyillisin, bu da seni belirsizlik rüzgarlarına karşı savunmasız bırakıyor. Dikkatini odaklamakta zorlandığında, evrenin sesini gürültü olarak algılayabilirsin."
        }
    }
    
    private var adviceContent: String {
        if type == .strengths {
            return "Işığını paylaşırken kendi enerjini korumayı unutma. Pozitif aurana çekilenlerin enerjini tüketmesine izin verme."
        } else {
            return "Sık sık topraklanma ritüelleri yapmalı, başkalarının dertlerini kendi yükün haline getirmekten kaçınmalı ve her sabah zihnini koruyucu bir kalkanla çevrelediğini hayal etmelisin."
        }
    }
}
