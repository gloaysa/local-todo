//
//  ReminderDateAndTime.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 21/1/24.
//

import Foundation

struct TodoItemDateAndTime {
    var dueDate: Date?
    var dueTime: Date?
    
    init(date: Date?, time: Date?) {
        self.dueDate = date
        self.dueTime = time
    }
}
