import Foundation

enum PersonalityAnalysisService {
    
    /// Simulates a Claude API personality reading based on iris data
    static func generateReading(for iris: IrisInfo, userName: String) -> String {
        let name = userName.isEmpty ? "Stella" : userName
        
        let readings = [
            "blue": """
                Gözlerindeki \(iris.hexColor) derinliği ve \(iris.pattern) deseni, ruhunun engin bir okyanus gibi dingin ama bir o kadar da derin olduğuna işaret ediyor, \(name). 
                
                Sezgilerin tıpkı bir kutup yıldızı gibi sana rehberlik ediyor. Bu 'Mavi Safir' enerji, senin empati yeteneğinin ve sadakatinin bir yansıması. Çevrendeki insanların göremediği detayları görebilme ve sessizliğin içindeki bilge sesleri duyabilme yeteneğine sahipsin.
                
                Yıldızların mesajı açık: Güvenli alanının dışına çıkmaktan korkma, çünkü senin içindeki ışık her türlü karanlığı aydınlatacak kadar güçlü.
                """,
            "amber": """
                \(iris.hexColor) tonlarındaki bu sıcaklık ve \(iris.pattern) dokusu, içindeki sönmeyen 'Kehribar' ateşini temsil ediyor, \(name). 
                
                Senin enerjin toprak gibi sağlam ama güneş gibi canlandırıcı. Kararlılığın ve pratik zekân, hayatın fırtınalarında seni sarsılmaz kılıyor. Bu desen, senin kadim bir koruyucu ruha sahip olduğunu ve sevdiklerin için bir sığınak olduğunu gösteriyor.
                
                Kısa süre içinde yaratıcılığını konuşturacağın bir dönem başlayacak. Doğadan ve topraktan gelen gücü kullanmayı unutma.
                """,
            "green": """
                Gözlerindeki \(iris.hexColor) yansımaları ve \(iris.pattern) karmaşıklığı, doğanın yenileyici ve şifacı gücünü taşıdığını fısıldıyor, \(name).
                
                Sen bir 'Zümrüt' ruhsun. Uyum yeteneğin ve hayatı her yönüyle kucaklayan merakın, seni eşsiz kılıyor. İnsanların ruhsal yaralarını sarmak ve dengeyi kurmak için buradasın. Bu zümrüt pırıltı, bitmek bilmeyen bir büyüme ve gelişim arzusunun simgesi.
                
                Sezgilerini dinlediğinde, evrenin sana sunduğu gizli fırsatları göreceksin. Şifa senin ellerinde ve gözlerinde.
                """,
            "mystic": """
                Bu \(iris.hexColor) gizemi ve \(iris.pattern) belirsizliği, senin evrenin en nadide elementlerinden biri olduğunu gösteriyor, \(name).
                
                Senin ruhun bir 'Kozmik Bulut' gibi geniş ve sınırsız. Belirli kalıplara sığmıyor, sürekli dönüşüyorsun. Bilimle ruhun, mantıkla hayalin kesiştiği noktadasın. Analitik zekân, yüksek spiritüel farkındalığınla birleşince ortaya durdurulamaz bir güç çıkıyor.
                
                Kendi gizemine güven. Bazı soruların cevabı kelimelerde değil, evrenin sessizliğindedir.
                """
        ]
        
        if iris.colorName.contains("Blue") {
            return readings["blue"]!
        } else if iris.colorName.contains("Amber") || iris.colorName.contains("Brown") {
            return readings["amber"]!
        } else if iris.colorName.contains("Green") || iris.colorName.contains("Hazel") {
            return readings["green"]!
        } else {
            return readings["mystic"]!
        }
    }
}
