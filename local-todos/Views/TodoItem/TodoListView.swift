//
//  ReminderListView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import SwiftUI

extension Animation {
    static let customAnimation: Animation = .easeInOut(duration: 0.5) // Adjust duration and type as needed
}


struct TodoListView: View {
    let todos: FetchedResults<TodoItem>
    
    @State private var selectedTodo: TodoItem?
    @State private var showTodoDetail: Bool = false
    @FocusState private var inputHasFocus
    
    private func todoCheckedChanged(todo: TodoItem, isCompleted: Bool) {
        var editConfig = TodoItemUpdateDTO(todo: todo)
        editConfig.status = isCompleted
        
        do {
            try TodoItemService.updateTodoItem(todo: todo, updated: editConfig)
        } catch {
            print(error)
        }
    }
    
    private func onReminderSelected(todo: TodoItem?) {
        selectedTodo = todo
    }
    
    private func isReminderSelected(_ todo: TodoItem) -> Bool {
        selectedTodo?.objectID === todo.objectID
    }
    
    private func deleteReminder(_ todo: TodoItem) {
        do {
            try TodoItemService.deleteTodoItem(todo: todo)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        HStack {
            if todos.isEmpty {
                VStack {
                    Spacer()
                    Text("Looks like there is nothing to do")
                        .foregroundColor(.gray)
                        .opacity(0.4)
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                
                VStack {
                    List(todos) { todo in
                        TodoCellView(todo: todo, isSelected: isReminderSelected(todo)) { event in
                            switch event {
                            case .onSelect(let todo):
                                onReminderSelected(todo: todo)
                            case .onCheckChanged(let todo, let isCompleted):
                                todoCheckedChanged(todo: todo, isCompleted: isCompleted)
                            case .onInfo:
                                hideKeyboard()
                                showTodoDetail = true
                            case .onDelete(let todo):
                                deleteReminder(todo)
                            }
                        }
                        
                    }
                    .listStyle(.inset)
                    .sheet(
                        isPresented: $showTodoDetail,
                        onDismiss: { selectedTodo = nil }
                    ) {
                        if (selectedTodo != nil) {
                            TodoDetailView(todo: Binding($selectedTodo)!)
                        } else {
                            // TODO: Properly handle this
                            NavigationViewError(errorMessage: "The TodoItem could not be selected")
                        }
                        
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
        
        
}



struct ReminderListView_Preview: PreviewProvider {
    
    struct ReminderListViewContainer: View {
        @FetchRequest(sortDescriptors: [])
        private var todoResults: FetchedResults<TodoItem>
        
        var body: some View {
            TodoListView(todos: todoResults)
        }
    }
    
    static var previews: some View {
        ReminderListViewContainer()
            .environment(
                \.managedObjectContext,
                 CoreDataProvider.shared.persistentContainer.viewContext
            )
    }
    
    
}

