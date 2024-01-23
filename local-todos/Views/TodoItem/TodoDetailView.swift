//
//  ReminderDetailView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import SwiftUI

struct TodoDetailView: View {
	
	@Environment(\.dismiss) private var dismiss
	
	@Binding var todo: TodoItem
	@State var todoDTO: TodoItemUpdateDTO = TodoItemUpdateDTO()
	@State private var selectedUserList: UserList?
	
	private var isFormValid: Bool {
		!todoDTO.summary.isEmptyOrWhitespace
	}
	
	init(todo: Binding<TodoItem>) {
		_todo = todo
		_selectedUserList = State(initialValue: todo.userList.wrappedValue)
		_todoDTO = State(initialValue: TodoItemUpdateDTO(
			todo: todo.wrappedValue
		))
	}
	
	private func addMinuteToCurrentDate() -> Date {
		return Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
	}
	
	var body: some View {
		NavigationStack {
			List {
				Section {
					TextField("Title", text: $todoDTO.summary)
					TextField("Notes", text: $todoDTO.notes ?? "")
				}
				
				Section {
					Toggle(isOn: $todoDTO.hasDate) {
						HStack {
							Image(systemName: "calendar")
								.foregroundColor(.red)
							VStack {
								Text("Date")
								if todoDTO.hasDate {
									Text(formatDate(todoDTO.dueDate))
										.font(.caption)
								}
							}
							
						}
						
					}.onChange(of: todoDTO.hasDate) { oldValue, newValue in
						if newValue {
							todoDTO.dueDate = Date()
						} else {
							todoDTO.dueDate = nil
						}
					}
					
					if todoDTO.hasDate {
						DatePicker(
							"",
							selection: $todoDTO.dueDate ?? Date(),
							displayedComponents: .date
						)
						.datePickerStyle(.graphical)
					}
					
					Toggle(isOn: $todoDTO.hasTime) {
						HStack {
							Image(systemName: "clock")
								.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
							VStack {
								Text("Time")
								if todoDTO.hasDate {
									Text(formatTime(todoDTO.dueTime))
										.font(.caption)
								}
								
							}.frame(alignment: .leading)
							
						}
						
					}
					.onChange(of: todoDTO.hasTime) { oldValue, newValue in
						if newValue {
							todoDTO.dueTime = addMinuteToCurrentDate()
						} else {
							todoDTO.dueTime = nil
						}
					}
					
					if todoDTO.hasTime {
						DatePicker(
							"",
							selection: $todoDTO.dueTime ?? addMinuteToCurrentDate(),
							displayedComponents: .hourAndMinute
						)
						.datePickerStyle(.wheel)
					}
					
					Section {
						NavigationLink(
							destination: ListPickerView(selectedList: $selectedUserList),
							label: {
								HStack {
									Text("List")
									Spacer()
									Text(selectedUserList?.name ?? "")
								}
							}
						)
					}
				}
				
			} // end List
			.listStyle(.insetGrouped)
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text("Details")
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Done") {
						do {
							todo.userList = selectedUserList
							try TodoItemService.updateTodoItem(todo: todo, updated: todoDTO)
							
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
}

#Preview {
	TodoDetailView(todo: .constant(PreviewData.todo))
}
