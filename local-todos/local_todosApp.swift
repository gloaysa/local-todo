//
//  local_todosApp.swift
//  local-todos
//
//  Created by Guillermo Loaysa on 21/1/24.
//

import SwiftUI

@main
struct local_todosApp: App {
	
	init() {
		UNUserNotificationCenter.current().requestAuthorization(
			options: [.alert, .sound, .badge]) { granted, error in
				if granted {
					DispatchQueue.main.async {
						UIApplication.shared.registerForRemoteNotifications()
					}
				} else {
					// display message to the user
				}
			}
	}
	
	var body: some Scene {
		WindowGroup {
			HomeView()
				.environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
		}
	}
}
