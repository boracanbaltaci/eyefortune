import Foundation

struct QuizQuestion: Identifiable, Codable {
    let id: String
    let text: String
    let category: String
}

enum QuizAnswer: String, Codable {
    case yes = "Evet"
    case no = "Hayır"
}

struct PersonalityQuiz {
    static let questions: [QuizQuestion] = [
        QuizQuestion(id: "q1", text: "Yeni bir yere gittiğimde önce etrafımdaki enerjiyi hissederim.", category: "Sezgi"),
        QuizQuestion(id: "q2", text: "Karar verirken mantığımdan çok iç sesime güvenirim.", category: "Karar Verme"),
        QuizQuestion(id: "q3", text: "Rüyalarımın çoğu zaman gerçekleştiğine şahit olurum.", category: "Sezgi"),
        QuizQuestion(id: "q4", text: "Kalabalık ortamlarda insanların duygularını hemen anlarım.", category: "Empati"),
        QuizQuestion(id: "q5", text: "Doğada vakit geçirmek ruhumu her zaman tazeler.", category: "Enerji"),
        QuizQuestion(id: "q6", text: "Küçük detaylar yerine büyük resme odaklanmayı tercih ederim.", category: "Algı"),
        QuizQuestion(id: "q7", text: "Başkalarına yardım etmek bana derin bir huzur verir.", category: "Empati"),
        QuizQuestion(id: "q8", text: "Planlarımın aniden değişmesi beni endişelendirmez.", category: "Esneklik"),
        QuizQuestion(id: "q9", text: "Yalnız kalmak benim için bir ihtiyaçtır.", category: "İçsel Denge"),
        QuizQuestion(id: "q10", text: "Geçmişteki hatalarımdan ders çıkarmak benim için kolaydır.", category: "Gelişim"),
        QuizQuestion(id: "q11", text: "Gelecek hakkında düşünürken genellikle heyecanlıyımdır.", category: "Bakış Açısı"),
        QuizQuestion(id: "q12", text: "Yaratıcı projeler üretmek beni motive eder.", category: "Yaratıcılık"),
        QuizQuestion(id: "q13", text: "İnsanların niyetlerini bakışlarından anlayabilirim.", category: "Sezgi"),
        QuizQuestion(id: "q14", text: "Hayatımda tesadüflere değil, eşzamanlılıklara inanırım.", category: "İnanç"),
        QuizQuestion(id: "q15", text: "Farklı görüşlere sahip insanlarla kolayca anlaşabilirim.", category: "Sosyal"),
        QuizQuestion(id: "q16", text: "Sabah saatleri benim için en verimli vakitlerdir.", category: "Ritim"),
        QuizQuestion(id: "q17", text: "Bir işe başlamadan önce tüm riskleri hesaplamayı severim.", category: "Mantık"),
        QuizQuestion(id: "q18", text: "Mistik ve gizemli konular her zaman ilgimi çekmiştir.", category: "Merak"),
        QuizQuestion(id: "q19", text: "Kendimi ifade ederken sanatsal yolları tercih ederim.", category: "Yaratıcılık"),
        QuizQuestion(id: "q20", text: "Hayatın bir amacı olduğuna ve her şeyin bir nedeni olduğuna inanırım.", category: "Felsefe")
    ]
}
