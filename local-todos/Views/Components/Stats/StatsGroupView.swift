//
//  StatsGroupView.swift
//  local-todos
//
//  Created by Guillermo Loaysa on 21/1/24.
//

import SwiftUI

struct StatsGroupView: View {
    
    @FetchRequest(fetchRequest: TodoItemService.todosByStatType(statType: .today))
    private var todayResults: FetchedResults<TodoItem>
    
    @FetchRequest(fetchRequest: TodoItemService.todosByStatType(statType: .scheduled))
    private var scheduledResults: FetchedResults<TodoItem>
    
    @FetchRequest(fetchRequest: TodoItemService.todosByStatType(statType: .all))
    private var allResults: FetchedResults<TodoItem>
    
    @FetchRequest(fetchRequest: TodoItemService.todosByStatType(statType: .completed))
    private var completedResults: FetchedResults<TodoItem>
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink {
                    TodoListView(todos: todayResults)
                } label: {
                    StatsCellView(
                        icon: "calendar",
                        title: "Today",
                        count: todayResults.count,
                        iconColor: .blue
                    )
                }
                
                NavigationLink {
                    TodoListView(todos: scheduledResults)
                } label: {
                    StatsCellView(
                        icon: "calendar.circle.fill",
                        title: "Scheduled",
                        count: scheduledResults.count,
                        iconColor: .red
                    )
                }
                
            }
            
            HStack {
                NavigationLink {
                    TodoListView(todos: allResults)
                } label: {
                    StatsCellView(
                        icon: "tray.circle.fill",
                        title: "All",
                        count: allResults.count,
                        iconColor: .gray
                    )
                }
                
                NavigationLink {
                    TodoListView(todos: completedResults)
                } label: {
                    StatsCellView(
                        icon: "checkmark.circle.fill",
                        title: "Completed",
                        count: completedResults.count,
                        iconColor: .green
                    )
                }
            }
        }.padding(.horizontal)
    }
}

#Preview {
    StatsGroupView()
}
