//
//  FormatDate.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import Foundation

func formatDate(_ date: Date?) -> String {
    if date == nil {
        return ""
    }
    if date!.isToday {
        return "Today"
    } else if date!.isTomorrow {
        return "Tomorrow"
    } else {
        return date!.formatted(date: .numeric, time: .omitted)
    }
}

func formatTime(_ time: Date?) -> String {
    if time == nil {
        return ""
    }
    
    return time!.formatted(date: .omitted, time: .shortened)
}
