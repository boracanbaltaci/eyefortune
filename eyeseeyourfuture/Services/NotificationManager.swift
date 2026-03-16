import Foundation
import UserNotifications
import SwiftUI
import Combine

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    // Using UserDefaults directly as @AppStorage is primarily for View/App
    private let defaults = UserDefaults.standard
    
    var notificationsEnabled: Bool {
        get { 
            if defaults.object(forKey: "notificationsEnabled") == nil {
                return true // Varsayılan olarak açık
            }
            return defaults.bool(forKey: "notificationsEnabled")
        }
        set { defaults.set(newValue, forKey: "notificationsEnabled") }
    }
    
    private var lastOpenDate: Double {
        get { defaults.double(forKey: "lastOpenDate") }
        set { defaults.set(newValue, forKey: "lastOpenDate") }
    }
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
                self.scheduleAllNotifications()
            } else if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    func updateLastOpenDate() {
        lastOpenDate = Date().timeIntervalSince1970
        // Reschedule inactivity notification
        scheduleInactivityNotification()
    }
    
    func scheduleAllNotifications() {
        guard notificationsEnabled else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            return
        }
        
        scheduleDailyNotification()
        scheduleMonthlyNotification()
        scheduleInactivityNotification()
    }
    
    func triggerTestNotifications() {
        let currentLang = LocalizationManager().language
        let titles = [getLocalized(.notifTitle, lang: currentLang), getLocalized(.notifTitle, lang: currentLang), getLocalized(.notifTitle, lang: currentLang)]
        let bodies = [
            getLocalized(.notifDaily, lang: currentLang),
            getLocalized(.notifInactivity, lang: currentLang),
            getLocalized(.notifMonthly, lang: currentLang)
        ]
        
        for i in 0..<3 {
            let content = UNMutableNotificationContent()
            content.title = titles[i]
            content.body = bodies[i]
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(i + 1) * 2, repeats: false)
            let request = UNNotificationRequest(identifier: "test_notif_\(i)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func sendDailyFortuneReadyNotification(language: AppLanguage) {
        guard notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = getLocalized(.notifTitle, lang: language)
        content.body = getLocalized(.notifFortuneReady, lang: language)
        content.sound = .default
        
        // Immediate (5 seconds)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "fortune_ready_\(UUID().uuidString)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Internal Scheduling Helpers
    private func getLocalized(_ key: LKey, lang: AppLanguage? = nil) -> String {
        let lm = LocalizationManager()
        return lm.t(key, language: lang)
    }
    
    private func scheduleDailyNotification() {
        let currentLang = LocalizationManager().language
        let content = UNMutableNotificationContent()
        content.title = getLocalized(.notifTitle, lang: currentLang)
        content.body = getLocalized(.notifDaily, lang: currentLang)
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_fortune", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleInactivityNotification() {
        let currentLang = LocalizationManager().language
        let content = UNMutableNotificationContent()
        content.title = getLocalized(.notifTitle, lang: currentLang)
        content.body = getLocalized(.notifInactivity, lang: currentLang)
        content.sound = .default
        
        // 3 days: 3 * 24 * 60 * 60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3 * 24 * 60 * 60, repeats: false)
        let request = UNNotificationRequest(identifier: "inactivity_check", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["inactivity_check"])
        UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleMonthlyNotification() {
        let currentLang = LocalizationManager().language
        let content = UNMutableNotificationContent()
        content.title = getLocalized(.notifTitle, lang: currentLang)
        content.body = getLocalized(.notifMonthly, lang: currentLang)
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "monthly_fortune", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
