//
//  NotifcationManager.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 20/1/24.
//

import Foundation
import UserNotifications

import UserNotifications

/// `NotificationManager` is responsible for scheduling, editing, and deleting notifications using `UNUserNotificationCenter`.
class NotificationService {
	
	/// Schedules a new notification based on the provided `TodoItem`.
	///
	/// - Parameters:
	///   - notificationData: The `TodoItem` object containing information for the notification.
	static func scheduleNotification(notificationData: TodoItem) {
		let content = UNMutableNotificationContent()
		content.title = notificationData.summary ?? "No title"
		content.body = notificationData.notes ?? ""
		
		// Extract date components from the todo date or use the current date
		var dateComponents = Calendar.current.dateComponents(
			[.year, .month, .day, .hour, .minute],
			from: notificationData.dueDate ?? Date()
		)
		
		// If todo has specific time, overwrite hour and minute
		if let todoTime = notificationData.dueTime {
			let todoTimeDateComponents = todoTime.dateComponents
			dateComponents.hour = todoTimeDateComponents.hour
			dateComponents.minute = todoTimeDateComponents.minute
		}
		
		// Create a calendar trigger for the notification
		let trigger = UNCalendarNotificationTrigger(
			dateMatching: dateComponents,
			repeats: false
		)
		
		// Create a notification request with a unique identifier
		let request = UNNotificationRequest(
			identifier: notificationData.objectID.uriRepresentation().absoluteString,
			content: content,
			trigger: trigger
		)
		
		// Add the notification request to the notification center
		UNUserNotificationCenter.current().add(request)
	}
	
	/// Edits an existing notification by canceling the old one and scheduling a new one with updated data.
	///
	/// - Parameters:
	///   - todoId: The original `TodoItem` id whose notification needs to be edited.
	///   - newReminder: The updated `TodoItem` object containing new information for the notification.
	static func editNotification(todoId: String, newTodo: TodoItem) {
		// First, cancel the existing notification
		deleteNotification(identifier: todoId)
		
		// Schedule a new notification with the updated data
		scheduleNotification(notificationData: newTodo)
	}
	
	/// Deletes a pending notification with the given identifier.
	///
	/// - Parameter identifier: The unique identifier of the notification to be deleted.
	static func deleteNotification(identifier: String) {
		// Cancel the notification with the given identifier
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
	}
}

