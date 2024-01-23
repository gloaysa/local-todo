//
//  StatsGroupView.swift
//  local-todos
//
//  Created by Guillermo Loaysa on 21/1/24.
//

import SwiftUI

struct Stat {
	let icon: String
	let title: String
	let count: Int
	let iconColor: Color
}


struct StatsGroupView: View {
    
    @FetchRequest(fetchRequest: TodoItemService.todosByStatType(statType: .today))
    private var todayResults: FetchedResults<TodoItem>
    
    @FetchRequest(fetchRequest: TodoItemService.todosByStatType(statType: .scheduled))
    private var scheduledResults: FetchedResults<TodoItem>
    
    @FetchRequest(fetchRequest: TodoItemService.todosByStatType(statType: .all))
    private var allResults: FetchedResults<TodoItem>
    
    @FetchRequest(fetchRequest: TodoItemService.todosByStatType(statType: .completed))
    private var completedResults: FetchedResults<TodoItem>
	
	private var stats: [Stat] {
		[
			Stat(icon: "calendar", title: "Today", count: todayResults.count, iconColor: .blue),
			Stat(icon: "calendar.circle.fill", title: "Scheduled", count: scheduledResults.count, iconColor: .red),
			Stat(icon: "tray.circle.fill", title: "All", count: allResults.count, iconColor: .gray),
			Stat(icon: "checkmark.circle.fill", title: "Completed", count: completedResults.count, iconColor: .green)
		]
	}

	
    
    var body: some View {
        VStack {
            HStack {
				
                NavigationLink {
                    TodoListView(todos: todayResults)
                } label: {
                    StatsCellView(
						icon: stats[0].icon,
						title: stats[0].title,
						count: stats[0].count,
						iconColor: stats[0].iconColor
                    )
                }
                
                NavigationLink {
                    TodoListView(todos: scheduledResults)
                } label: {
                    StatsCellView(
						icon: stats[1].icon,
						title: stats[1].title,
						count: stats[1].count,
						iconColor: stats[1].iconColor
                    )
                }
                
            }
            
            HStack {
                NavigationLink {
                    TodoListView(todos: allResults)
                } label: {
                    StatsCellView(
						icon: stats[2].icon,
						title: stats[2].title,
						count: stats[2].count,
						iconColor: stats[2].iconColor
                    )
                }
                
                NavigationLink {
                    TodoListView(todos: completedResults)
                } label: {
                    StatsCellView(
						icon: stats[3].icon,
						title: stats[3].title,
						count: stats[3].count,
						iconColor: stats[3].iconColor
                    )
				}
            }
        }
		.padding(.horizontal)
    }
}

#Preview {
    StatsGroupView()
}
