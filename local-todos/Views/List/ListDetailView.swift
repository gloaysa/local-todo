//
//  UserListDetailView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import SwiftUI

struct ListDetailView: View {
	let userList: UserList
	
	@State private var openAddReminder: Bool = false
	@State private var title: String = ""
	
	@FetchRequest(sortDescriptors: [])
	private var todoResults: FetchedResults<TodoItem>
	
	private var isFormValid: Bool {
		!title.isEmptyOrWhitespace
	}
	
	init(userList: UserList) {
		self.userList = userList
		_todoResults = FetchRequest(fetchRequest: TodoItemService.getTodoItemsNotDoneByList(userList: userList))
	}
	
	var body: some View {
		
		VStack(alignment: .leading) {
			
			VStack(alignment: .leading) {
				
				// Display list of reminders
				TodoListView(todos: todoResults)
				
				Button("New TodoItem", systemImage: "plus.circle.fill") {
					openAddReminder = true
				}
				.foregroundColor(.blue)
				.font(.title3)
				.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
				.padding()
			}.sheet(isPresented: $openAddReminder) {
				NavigationStack {
					TodoCreateView(userList: userList)
				}
				
			}            
		}
		.navigationTitle(userList.name!)
		.toolbarBackground(userList.color, for: .navigationBar)
		.padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
		
		
	}
}


#Preview {
	ListDetailView(userList: PreviewData.userList)
}
