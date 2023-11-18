//
//  NotificationManager.swift
//  ToDoList
//
//  Created by Ayush Narwal on 18/11/23.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    
    var items: [Item] = []
    
    func setItems(items: [Item]){
        self.items = items
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func scheduleNotifications() {
        // Remove existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Schedule notifications every two hours
        let timer = Timer.scheduledTimer(withTimeInterval: 2 * 60 * 60, repeats: true) { _ in
            self.sendNotification(items: self.items)
        }
        // Ensure the timer keeps running even when the app is in the background
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func sendNotification(items: [Item]) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = items.randomElement()?.text ?? "" // chooses a random element from the items present in the local storage
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
}
