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
	@State private var timeAddedAutomatically: Bool = false
	@State private var dateAddedAutomatically: Bool = false
	
	@FocusState private var isViewAppeared: Bool
	@FocusState private var isNotesTapped: Bool
	
	private var isFormValid: Bool {
		!todoToCreate.summary.isEmptyOrWhitespace
	}
	
	func detectDateBeginningString(from string: String) -> Date? {
		// Use a regular expression to capture the time part
		let regex = try? NSRegularExpression(pattern: "^\\d{1,2}/\\d{1,2}/\\d{2}$")
		let range = NSRange(string.startIndex..<string.endIndex, in: string)
		if let match = regex?.firstMatch(in: string, options: [], range: range),
		   let timeRange = Range(match.range(at: 0), in: string) {
			
			let timeString = String(string[timeRange])
			
			let types: NSTextCheckingResult.CheckingType = [.date]
			let detector = try? NSDataDetector(types: types.rawValue)
			let matches = detector?.matches(in: timeString, options: [], range: NSRange(timeString.startIndex..<timeString.endIndex, in: timeString))
			
			return matches?.first?.date
		}
		
		return nil
	}
	
	func detectTimeBeginningString(from string: String) -> Date? {
		// Use a regular expression to capture the time part
		let regex = try? NSRegularExpression(pattern: "(\\d{1,2}:\\d{2})")
		let range = NSRange(string.startIndex..<string.endIndex, in: string)
		if let match = regex?.firstMatch(in: string, options: [], range: range),
		   let timeRange = Range(match.range(at: 1), in: string) {
			
			let timeString = String(string[timeRange])
			
			let types: NSTextCheckingResult.CheckingType = [.date]
			let detector = try? NSDataDetector(types: types.rawValue)
			let matches = detector?.matches(in: timeString, options: [], range: NSRange(timeString.startIndex..<timeString.endIndex, in: timeString))
			
			return matches?.first?.date
		}
		
		return nil
	}

	
	init(userList: UserList) {
		// Initialize selectedUserList with the first user list when the view is created
		_defaultUserList = State(initialValue: userList)
		
		self.userList = userList
		_todoToCreate = State(initialValue: TodoItemCreateDTO())
	}
	
	var body: some View {
		VStack {
			Form {
				Section {
					TextField("Title", text: $todoToCreate.summary)
						.focused($isViewAppeared)
						.onChange(of: todoToCreate.summary) { oldValue, newValue in
							if (newValue == oldValue + " ") {
								return
							}
							let time = detectTimeBeginningString(from: newValue)
							
							if time != nil && !todoToCreate.hasTime {
								todoToCreate.hasTime = true
								todoToCreate.dueTime = time
								timeAddedAutomatically = true
							}
							if time == nil && timeAddedAutomatically {
								todoToCreate.hasTime = false
								todoToCreate.dueTime = nil
								timeAddedAutomatically = false
							}
							
							let date = detectDateBeginningString(from: newValue)
							print(date)
							if date != nil && !todoToCreate.hasDate {
								todoToCreate.hasDate = true
								todoToCreate.dueDate = date
								dateAddedAutomatically = true
							}
							if date == nil && dateAddedAutomatically {
								todoToCreate.hasDate = false
								todoToCreate.dueDate = nil
								dateAddedAutomatically = false
							}
						}

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
							todoToCreate.dueDate = todoToCreate.dueDate ?? Date()
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
							todoToCreate.dueTime = todoToCreate.dueTime ?? Date()
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
