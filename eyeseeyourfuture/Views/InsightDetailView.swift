import SwiftUI

struct InsightDetailView: View {
    let type: InsightType
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    enum InsightType {
        case strengths
        case weaknesses
        
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
        NavigationView {
            ZStack {
                themeManager.bgColor.ignoresSafeArea()
                
                // Decorative elements
                VStack {
                    Circle()
                        .fill(type.mainColor.opacity(0.05))
                        .frame(width: 300, height: 300)
                        .blur(radius: 50)
                        .offset(y: -150)
                    Spacer()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        // Header Icon
                        ZStack {
                            Circle()
                                .stroke(type.mainColor.opacity(0.2), lineWidth: 1)
                                .frame(width: 140, height: 140)
                            
                            Circle()
                                .fill(type.mainColor.opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: type.icon)
                                .font(.system(size: 60))
                                .foregroundColor(type.mainColor)
                                .shadow(color: type.mainColor.opacity(0.3), radius: 10)
                        }
                        .padding(.top, 40)
                        
                        // Content Card
                        VStack(alignment: .leading, spacing: 25) {
                            HStack {
                                Text(type.title.uppercased())
                                    .font(.system(size: 14, weight: .black))
                                    .tracking(2)
                                    .foregroundColor(type.mainColor)
                                Spacer()
                                Image(systemName: "sparkles")
                                    .foregroundColor(type.mainColor.opacity(0.5))
                            }
                            
                            Text(insightContent)
                                .font(.system(size: 18, weight: .medium, design: .serif))
                                .lineSpacing(8)
                                .foregroundColor(themeManager.primaryTextColor)
                            
                            // Advice placeholder
                            VStack(alignment: .leading, spacing: 10) {
                                Text("ORAKIL TAVSİYESİ")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                
                                Text(adviceContent)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(themeManager.primaryTextColor)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(type.mainColor.opacity(0.05))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(30)
                        .background(themeManager.cardBgColor)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(type.mainColor.opacity(0.1), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(themeManager.secondaryTextColor.opacity(0.6))
                    }
                }
            }
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private var insightContent: String {
        if type == .strengths {
            return "Ruhsal haritan, derin bir sezgisel güce ve empatik bir auraya sahip olduğunu gösteriyor. İnsanların söyleyemediklerini hissetme yeteneğin, seni çevrendeki karanlıkta bir fener yapıyor. Kararlılığın ve içsel dengen, en fırtınalı anlarda bile seni ayakta tutan en büyük müttefikin."
        } else {
            return "Kozmik enerjin bazen aşırı hassasiyet nedeniyle dağılabiliyor. Başkalarının enerjilerini sünger gibi çekmen, kendi ruhsal merkezinden uzaklaşmana neden olabilir. Kararsızlık anlarında evrenin işaretlerini yanlış yorumlamaya meyillisin, bu da seni belirsizlik rüzgarlarına karşı savunmasız bırakıyor."
        }
    }
    
    private var adviceContent: String {
        if type == .strengths {
            return "Işığını paylaşırken kendi enerjini korumayı unutma. Pozitif aurana çekilenlerin enerjini tüketmesine izin verme."
        } else {
            return "Sık sık topraklanma ritüelleri yapmalı ve başkalarının dertlerini kendi yükün haline getirmekten kaçınmalısın."
        }
    }
}
