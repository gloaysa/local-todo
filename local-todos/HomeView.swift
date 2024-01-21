//
//  ContentView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 17/1/24.
//

import SwiftUI
import CoreData

struct HomeView: View {
	@Environment(\.managedObjectContext) private var viewContext
	
	@FetchRequest(sortDescriptors: [])
	private var userListResults: FetchedResults<UserList>
	@FetchRequest(sortDescriptors: [])
	private var searchResults: FetchedResults<TodoItem>
	
	@State private var createNewListActive: Bool = false
	@State private var createNewReminderActive: Bool = false
	@State private var search: String = ""
	@State private var searching: Bool = false
	
	private func deleteAllRecords() {
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserList")
		
		do {
			let objects = try viewContext.fetch(fetchRequest)
			for case let object as NSManagedObject in objects {
				viewContext.delete(object)
			}
			try viewContext.save()
		} catch {
			print("Error deleting records: \(error)")
		}
	}
	
	var body: some View {
		NavigationStack {
			if searching {
				VStack {
					TodoListView(todos: searchResults)
				}.frame(maxWidth: .infinity, maxHeight: .infinity)
				
			} else {
				VStack {
					
					// Button("Delete All Records") {deleteAllRecords()}
					
					StatsGroupView()
					
					ListsView(userLists: userListResults)
					
					
					HStack {
						
						Button("New Todo", systemImage: "plus.circle.fill") {
							createNewReminderActive = true
						}
						.font(.title3)
						.disabled(userListResults.isEmpty)
						.foregroundColor(userListResults.isEmpty ? Color.gray : Color.blue)
						.padding()
						
						Button {
							createNewListActive = true
						} label: {
							Text("Add list")
								.frame(maxWidth: .infinity, alignment: .trailing)
						}.padding()
					}
				}
				.sheet(isPresented: $createNewListActive) {
					NavigationStack {
						let tempUserList = UserListService.getTemporalUserList()
						ListCreateView(
							userList: tempUserList,
							onDismiss: {
								UserListService.deleteTemporalUserList(tempUserList)
							}
						) { userList in
							do {
								try UserListService.createUserList(userList)
							} catch {
								print(error)
							}
						}
						
					}
				}
				.sheet(isPresented: $createNewReminderActive) {
					NavigationStack {
						TodoCreateView(userList: userListResults[0])
					}
				}.navigationTitle("Local Todos")
			}
		}
		.searchable(text: $search)
		.searchable(text: $search)
		.onChange(of: search) { old, searchTerm in
			searching = !searchTerm.isEmpty ? true : false
			searchResults.nsPredicate = TodoItemService.getTodoItemsBySearch(search).predicate
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
			.environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
	}
}
