//
//  AddNewReminderView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 19/1/24.
//

import SwiftUI

struct TodoCreateView: View {
    @Environment(\.dismiss) private var dismiss
    
    let userList: UserList
    
    @State private var todoToCreate: TodoItemCreateDTO = TodoItemCreateDTO()
    @State private var defaultUserList: UserList?
    @FocusState private var isViewAppeared: Bool
    
    private var isFormValid: Bool {
        !todoToCreate.summary.isEmptyOrWhitespace
    }
    
    init(userList: UserList) {
        // Initialize selectedUserList with the first user list when the view is created
        _defaultUserList = State(initialValue: userList)
        
        self.userList = userList
        _todoToCreate = State(initialValue: TodoItemCreateDTO())
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    TextField("Title", text: $todoToCreate.summary)
                        .focused($isViewAppeared)
                    TextField("Notes", text: $todoToCreate.notes ?? "")
                }
                
                Section {
                    Toggle(isOn: $todoToCreate.hasDate) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.red)
                            VStack {
                                Text("Date")
                                if todoToCreate.hasDate {
                                    Text(formatDate(todoToCreate.dueDate))
                                        .font(.caption)
                                }
                            }
                            
                        }
                        
                    }.onChange(of: todoToCreate.hasDate) { oldValue, newValue in
                        if newValue {
                            todoToCreate.dueDate = Date()
                        } else {
                            todoToCreate.dueTime = nil
                        }
                    }
                    
                    if todoToCreate.hasDate {
                        DatePicker(
                            "",
                            selection: $todoToCreate.dueDate ?? Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                    }
                    
                    Toggle(isOn: $todoToCreate.hasTime) {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            VStack {
                                Text("Time")
                                if todoToCreate.hasDate {
                                    Text(formatTime(todoToCreate.dueTime))
                                        .font(.caption)
                                }
                                
                            }.frame(alignment: .leading)
                            
                        }
                        
                    }.onChange(of: todoToCreate.hasTime) { oldValue, newValue in
                        if newValue {
                            todoToCreate.dueTime = Date()
                        } else {
                            todoToCreate.dueTime = nil
                        }
                    }
                    
                    if todoToCreate.hasTime {
                        DatePicker(
                            "",
                            selection: $todoToCreate.dueTime ?? Date(),
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                    }
                    
                    Section {
                        NavigationLink(
                            destination: ListPickerView(selectedList: $defaultUserList),
                            label: {
                                HStack {
                                    Text("List")
                                    Spacer()
                                    Text(defaultUserList?.name ?? "")
                                }
                            }
                        )
                    }
                }
            }.listStyle(.insetGrouped)
        }
        .onAppear {
            isViewAppeared = true
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Details")
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    do {
                        try TodoItemService.createTodoItem(
                            userList: defaultUserList!,
                            createConfig: todoToCreate
                        )
                        
                        dismiss()
                    } catch {
                        print(error)
                    }
                }.disabled(!isFormValid)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

struct CreateTodoView_Preview: PreviewProvider {
    
    struct CreateTodoContainer: View {
        
        var body: some View {
            TodoCreateView(userList: PreviewData.userList)
        }
    }
    
    static var previews: some View {
        CreateTodoContainer()
            .environment(
                \.managedObjectContext,
                 CoreDataProvider.shared.persistentContainer.viewContext
            )
    }
    
}
