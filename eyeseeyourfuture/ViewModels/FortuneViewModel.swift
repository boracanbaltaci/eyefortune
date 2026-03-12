import Foundation
import Combine
import SwiftUI

class FortuneViewModel: ObservableObject {
    @Published var dailyFortune: Fortune?
    @Published var isLoading: Bool = false
    
    // In a real app, this would use UserDefaults or CoreData
    @Published var savedFortunes: [Fortune] = [] {
        didSet {
            saveFortunes()
        }
    }
    
    private let saveKey = "saved_fortunes_list"
    
    init() {
        loadFortunes()
        fetchDailyFortune()
    }
    
    private func saveFortunes() {
        if let encoded = try? JSONEncoder().encode(savedFortunes) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadFortunes() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Fortune].self, from: data) {
            savedFortunes = decoded
        }
    }
    
    func fetchDailyFortune() {
        isLoading = true
        // Simulate network request or DB fetch delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let fortuneTexts = [
                "Bugün gözlerindeki parıltı, evrenin sana fısıldadığı büyük bir yeniliğin habercisi. Ruhun, geçmişin yüklerinden arınarak yeni bir döngüye girmeye hazır. Önümüzdeki günlerde karşına çıkacak olan beklenmedik fırsatlar, hayatının akışını tahmin edemeyeceğin kadar olumlu yönde değiştirebilir. İçindeki bilgeliğe güven ve sezgilerinin seni doğru kapıya ulaştırmasına izin ver.",
                "İçindeki kadim güç bugün her zamankinden daha belirgin bir şekilde dışarı yansıyor. Etrafındaki insanlar senin auranın yarattığı o sakinleştirici ve yol gösterici enerjiyi hissedecekler. Liderlik etme ve vizyonunu paylaşma zamanı geldi. Karşılaştığın engeller, aslında senin iradeni güçlendirmek için karşında duruyor. Bugün attığın her adım, gelecekteki büyük zaferlerinin temelini oluşturacak.",
                "Göz bebeklerinin derinliklerinde saklı olan o mistik ışık, çok yakında alacağın ve hayatında yeni bir sayfa açacak olan müjdeli bir habere işaret ediyor. Maddi ve manevi bolluğun kapıları senin için aralanıyor. Sabırla beklediğin o an, yıldızların hizalanmasıyla birlikte gerçeğe dönüşmek üzere. Kalbini açık tut ve evrenin sana sunduğu bu eşsiz hediyeyi sevgiyle kabul et.",
                "Zihnin bugün kozmik bir berraklık içinde; karar vermekte zorlandığın o karmaşık meseleler artık gün gibi ortada. Kendi iç sesini dinlediğinde, aslında en doğru cevabın hep orada olduğunu fark edeceksin. Cesaretini topla ve o beklenen kararı ver. Hayatındaki eski enerjileri serbest bırakarak, yeni başlangıçlar için yer açmanın tam sırası. Yolun aydınlık, şansın daim olsun."
            ]
            
            let randomText = fortuneTexts.randomElement() ?? "Harika bir gün seni bekliyor."
            
            self.dailyFortune = Fortune(
                text: randomText,
                dateGenerated: Date(),
                type: .daily
            )
            self.isLoading = false
        }
    }
}
