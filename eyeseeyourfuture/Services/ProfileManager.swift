import Foundation
import SwiftUI
import Combine

struct UserProfile: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var birthDate: String
    var irisHex: String
    var irisColorName: String
    var irisReading: String
    var scannedEyeImagePath: String?
}

class ProfileManager: ObservableObject {
    @AppStorage("activeProfileId") var activeProfileId: String = ""
    @Published var profiles: [UserProfile] = []
    
    static let shared = ProfileManager()
    
    private let profilesKey = "saved_user_profiles"
    
    init() {
        loadProfiles()
        if profiles.isEmpty {
            createDefaultProfile()
        }
    }
    
    func loadProfiles() {
        if let data = UserDefaults.standard.data(forKey: profilesKey),
           let decoded = try? JSONDecoder().decode([UserProfile].self, from: data) {
            self.profiles = decoded
        }
    }
    
    func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: profilesKey)
        }
    }
    
    private func createDefaultProfile() {
        // Migration of existing AppStorage data to first profile
        let existingName = UserDefaults.standard.string(forKey: "userName") ?? "Oracle Seer"
        let existingBirthDate = UserDefaults.standard.string(forKey: "userBirthDate") ?? ""
        let existingIrisHex = UserDefaults.standard.string(forKey: "irisHex") ?? "#4A90E2"
        let existingIrisColorName = UserDefaults.standard.string(forKey: "irisColorName") ?? "Deep Blue"
        let existingIrisReading = UserDefaults.standard.string(forKey: "irisReading") ?? ""
        let existingImagePath = UserDefaults.standard.string(forKey: "scannedEyeImagePath")
        
        let firstProfile = UserProfile(
            name: existingName,
            birthDate: existingBirthDate,
            irisHex: existingIrisHex,
            irisColorName: existingIrisColorName,
            irisReading: existingIrisReading,
            scannedEyeImagePath: existingImagePath
        )
        
        profiles = [firstProfile]
        activeProfileId = firstProfile.id.uuidString
        saveProfiles()
    }
    
    var activeProfile: UserProfile? {
        profiles.first { $0.id.uuidString == activeProfileId }
    }
    
    func switchProfile(to profile: UserProfile) {
        objectWillChange.send()
        activeProfileId = profile.id.uuidString
        // Update legacy AppStorage keys to maintain compatibility with existing views
        syncLegacyData(with: profile)
    }
    
    func addNewProfile(name: String, birthDate: String) -> UserProfile {
        let newProfile = UserProfile(
            name: name,
            birthDate: birthDate,
            irisHex: "#4A90E2",
            irisColorName: "Scanning...",
            irisReading: ""
        )
        profiles.append(newProfile)
        saveProfiles()
        return newProfile
    }
    
    func createPlaceholderProfile() -> UserProfile {
        let newProfile = UserProfile(
            name: "New Profile",
            birthDate: "",
            irisHex: "#4A90E2",
            irisColorName: "Scanning...",
            irisReading: ""
        )
        profiles.append(newProfile)
        activeProfileId = newProfile.id.uuidString
        saveProfiles()
        syncLegacyData(with: newProfile)
        return newProfile
    }
    
    func updateActiveProfileInfo(name: String, birthDate: String) {
        objectWillChange.send()
        guard let index = profiles.firstIndex(where: { $0.id.uuidString == activeProfileId }) else { return }
        profiles[index].name = name
        profiles[index].birthDate = birthDate
        saveProfiles()
        syncLegacyData(with: profiles[index])
    }
    
    func updateActiveProfileIris(hex: String, nameColor: String, reading: String, imagePath: String?) {
        objectWillChange.send()
        guard let index = profiles.firstIndex(where: { $0.id.uuidString == activeProfileId }) else { return }
        profiles[index].irisHex = hex
        profiles[index].irisColorName = nameColor
        profiles[index].irisReading = reading
        profiles[index].scannedEyeImagePath = imagePath
        saveProfiles()
        syncLegacyData(with: profiles[index])
    }
    
    func syncLegacyData(with profile: UserProfile) {
        UserDefaults.standard.set(profile.name, forKey: "userName")
        UserDefaults.standard.set(profile.birthDate, forKey: "userBirthDate")
        UserDefaults.standard.set(profile.irisHex, forKey: "irisHex")
        UserDefaults.standard.set(profile.irisColorName, forKey: "irisColorName")
        UserDefaults.standard.set(profile.irisReading, forKey: "irisReading")
        UserDefaults.standard.set(profile.scannedEyeImagePath, forKey: "scannedEyeImagePath")
    }
}
