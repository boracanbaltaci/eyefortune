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
        let lm = LocalizationManager()
        let titles = [lm.t(.notifTitle), lm.t(.notifTitle), lm.t(.notifTitle)]
        let bodies = [
            lm.t(.notifDaily),
            lm.t(.notifInactivity),
            lm.t(.notifMonthly)
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
    
    // MARK: - Internal Scheduling Helpers
    private func getLocalized(_ key: LKey) -> String {
        let lm = LocalizationManager()
        return lm.t(key)
    }
    
    private func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = getLocalized(.notifTitle)
        content.body = getLocalized(.notifDaily)
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_fortune", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleInactivityNotification() {
        let content = UNMutableNotificationContent()
        content.title = getLocalized(.notifTitle)
        content.body = getLocalized(.notifInactivity)
        content.sound = .default
        
        // 3 days: 3 * 24 * 60 * 60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3 * 24 * 60 * 60, repeats: false)
        let request = UNNotificationRequest(identifier: "inactivity_check", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["inactivity_check"])
        UNUserNotificationCenter.current().add(request)
    }
    
    private func scheduleMonthlyNotification() {
        let content = UNMutableNotificationContent()
        content.title = getLocalized(.notifTitle)
        content.body = getLocalized(.notifMonthly)
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
