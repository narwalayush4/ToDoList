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
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent ()
        content.title = "Reminder"
        content.body = items.randomElement()?.text ?? ""
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID() .uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    
    
}
