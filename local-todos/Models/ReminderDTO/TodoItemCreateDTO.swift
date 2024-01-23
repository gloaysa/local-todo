//
//  ReminderCreateDTO.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 21/1/24.
//

import Foundation

struct TodoItemCreateDTO {
	var summary: String = ""
	var notes: String?
	var status: Bool = false
	var dueDate: Date?
	var dueTime: Date?
	
	var hasDate: Bool = false
	var hasTime: Bool = false
	
	init() {
		summary = ""
		notes = nil
		status = false
		dueDate = nil
		dueTime = nil
		
		hasDate = false
		hasTime = false
	}
}
