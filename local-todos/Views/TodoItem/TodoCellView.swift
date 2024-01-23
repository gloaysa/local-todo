//
//  TodoCellView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import SwiftUI

enum TodoCellEvents {
	case onInfo
	case onCheckChanged(TodoItem, Bool)
	case onSelect(TodoItem?)
	case onDelete(TodoItem)
}

struct TodoCellView: View {
	
	let todo: TodoItem
	let isSelected: Bool
	let onEvent: (TodoCellEvents) -> Void
	
	private let delay = Delay()
	
	@State private var checked: Bool = false
	@State private var todoTitle: String
	@State private var todoNotes: String
	
	init(todo: TodoItem, isSelected: Bool, onEvent: @escaping (TodoCellEvents) -> Void) {
		self.todo = todo
		self.isSelected = isSelected
		self.onEvent = onEvent
		_todoTitle = State(initialValue: todo.summary ?? "")
		_todoNotes = State(initialValue: todo.notes ?? "")
	}
	
	var body: some View {
		HStack {
			Button {
				withAnimation {
					checked.toggle()
				}
			} label: {
				Label("", systemImage: checked ? "checkmark.circle.fill" : "circle")   
			}
			.foregroundColor(checked ? Color.blue : .gray)
			.onTapGesture {
				checked.toggle()
				
				delay.cancel()
				
				delay.delay {
					onEvent(.onCheckChanged(todo, checked))
				}
			}
			.font(.title2)
			.contentTransition(.symbolEffect(.replace))
			.onAppear {
				checked = todo.status
			}
			
			VStack(alignment: .leading, content: {
				TextField("",
						  text: $todoTitle,
						  onEditingChanged: { editing in
					if (!editing) {
						if (todoTitle != todo.summary) {
							do {
								try TodoItemService.updateTodoItemTitle(todo: todo, newTitle: todoTitle)
							} catch {
								print(error)
							}
							
						}
					}
				},
						  onCommit: { onEvent(.onSelect(nil)) }
				)
				
				if isSelected || !todoNotes.isEmpty {
					TextField("Add Note",
							  text: $todoNotes,
							  onEditingChanged: { editing in
						if (!editing) {
							if (todoNotes != todo.notes) {
								do {
									try TodoItemService.updateTodoItemNote(todo: todo, newNote: todoNotes)
								} catch {
									print(error)
								}
							}
						}
					},
							  onCommit: { onEvent(.onSelect(nil)) }
					)
					.font(.caption)
					.opacity(0.4)
				}
				
				HStack {
					if let todoDate = todo.dueDate {
						Text(formatDate(todoDate))
					}
					
					if let todoTime = todo.dueTime {
						Text(formatTime(todoTime))
					}
				}.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
					.font(.caption)
					.opacity(0.4)
			})
			
			Spacer()
			
			Image(systemName: "info.circle")
				.opacity(isSelected ? 1.0 : 0.0)
				.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
				.onTapGesture {
					onEvent(.onInfo)
				}
			
		}
		.swipeActions {
			Button("Details") {
				onEvent(.onSelect(todo))
				onEvent(.onInfo)
			}
			
			Button("Delete", role: .destructive) {
				onEvent(.onDelete(todo))
			}
		}
		.contentShape(Rectangle())
		.onTapGesture {
			onEvent(.onSelect(todo))
		}
	}
}

class TodoCellView_Previews: PreviewProvider {
	static var previews: some View {
		TodoCellView(
			todo: PreviewData.todo,
			isSelected: false,
			onEvent: { _ in }
		)
	}
}
