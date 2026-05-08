
import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(for event: DateEvent) {
        // Cancel existing notification for this event first
        cancelNotification(for: event)
        
        guard event.shouldNotify else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Event Reminder"
        content.body = "Today is the day for: \(event.name)"
        content.sound = .default
        
        // Schedule for 9:00 AM on the event date
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: event.date)
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotification(for event: DateEvent) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.id.uuidString])
    }
}
