import SwiftUI

struct HelpCenterView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    let faqs = [
        FAQItem(question: "Fallar ne kadar doğru?", answer: "Yapay zekamız, binlerce yıllık kadim bilgiler ve senin enerjinle harmanlanarak en yakın öngörüleri sunar. Unutma, gelecek senin niyetine göre şekillenir."),
        FAQItem(question: "Abonelik iptali nasıl yapılır?", answer: "Hesap ayarlarından 'Abonelik Yönetimi' kısmına giderek istediğin zaman iptal edebilirsin. Premium avantajların dönem sonuna kadar devam eder."),
        FAQItem(question: "Ruhsal verilerim güvende mi?", answer: "Kesinlikle. Tüm analizlerin uçtan uca şifrelenir ve sadece senin cihazında saklanır. Gizliliğin bizim için kutsaldır."),
        FAQItem(question: "Göz taraması nasıl çalışır?", answer: "İris yapındaki benzersiz desenler, ruhsal frekansının yansımasıdır. Yapay zekamız bu biyometrik verileri astrolojik verilerle eşleştirir."),
        FAQItem(question: "Yeni fallar ne zaman yenilenir?", answer: "Her sabah gün doğumuyla birlikte yıldız haritaları güncellenir ve yeni günlük falın hazır olur."),
        FAQItem(question: "Premium özellikler nelerdir?", answer: "Sınırsız göz taraması, detaylı kişilik analizi, ad-free deneyim ve özel ritüel rehberlerine erişim sağlarsın."),
        FAQItem(question: "Uygulama neden bazen yavaşlıyor?", answer: "Merkür retrosu dönemlerinde veya yoğun kozmik trafiğin olduğu anlarda sunucularımızda kısa süreli yoğunluk yaşanabilir.")
    ]
    
    var filteredFaqs: [FAQItem] {
        if searchText.isEmpty {
            return faqs
        } else {
            return faqs.filter { $0.question.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(themeManager.accentYellow)
                        TextField("Hangi cevabı arıyorsun?", text: $searchText)
                            .foregroundColor(themeManager.primaryTextColor)
                    }
                    .padding()
                    .background(themeManager.cardBgColor)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredFaqs) { item in
                                FAQRow(item: item, themeManager: themeManager)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Yardım Merkezi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") { dismiss() }
                        .foregroundColor(themeManager.accentYellow)
                }
            }
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FAQRow: View {
    let item: FAQItem
    @ObservedObject var themeManager: ThemeManager
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(item.question)
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(themeManager.accentYellow)
                }
                .padding(16)
            }
            
            if isExpanded {
                VStack(alignment: .leading) {
                    Divider().background(themeManager.accentYellow.opacity(0.1))
                    Text(item.answer)
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                        .lineSpacing(4)
                        .padding(16)
                }
            }
        }
        .background(themeManager.cardBgColor)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isExpanded ? themeManager.accentYellow.opacity(0.4) : themeManager.accentYellow.opacity(0.1), lineWidth: 1)
        )
    }
}
