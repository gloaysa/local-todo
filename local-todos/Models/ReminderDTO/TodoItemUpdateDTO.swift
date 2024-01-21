//
//  ReminderEditConfig.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import Foundation

struct TodoItemUpdateDTO {
    var summary: String = ""
    var notes: String?
    var status: Bool = false
    var hasDate: Bool = false
    var hasTime: Bool = false
    var dueDate: Date?
    var dueTime: Date?
    
    init() {}
    
    init(todo: TodoItem) {
        summary = todo.summary ?? ""
        notes = todo.notes
        status = todo.status
        dueDate = todo.dueDate
        dueTime = todo.dueTime
        
        hasDate = todo.dueDate != nil
        hasTime = todo.dueTime != nil
    }
    
}
