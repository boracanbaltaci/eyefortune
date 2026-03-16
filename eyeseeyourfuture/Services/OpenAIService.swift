import Foundation

class OpenAIService {
    static let shared = OpenAIService()
    
    // NOTE: In a real app, this should be stored securely (e.g., in KeyChain or fetched from a secure backend)
    // Fetches API key from Secrets.plist
    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist.object(forKey: "OPENAI_API_KEY") as? String else {
            print("Error: Secrets.plist not found or OPENAI_API_KEY missing.")
            return ""
        }
        return value
    }
    
    private let apiURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    private init() {}
    
    func generateFortune(prompt: String, model: String = "gpt-4o-mini", completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": "Sen bilge bir astrolog ve spiritüel danışmansın. Kullanıcılara derin, anlamlı ve etkileyici fallar yazıyorsun."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content))
                } else {
                    completion(.failure(NSError(domain: "OpenAIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
