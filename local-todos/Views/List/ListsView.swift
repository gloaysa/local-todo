//
//  SwiftUIView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import SwiftUI

struct ListsView: View {
	@Environment(\.colorScheme) var colorScheme
	
	let userLists: FetchedResults<UserList>
	
	private func deleteList(_ userList: UserList) {
		do {
			try UserListService.deleteUserList(userList)
		} catch {
			print(error)
		}
	}
	
	private func editList(_ userList: UserList) {
		do {
			try UserListService.editUserList(userList: userList)
		} catch {
			print(error)
		}
	}
	
	private func handleOnEvent(_ event: ListCellEvents) {
		switch event {
		case .onEdit(let userList):
			editList(userList)
		case .onDelete(let userList):
			deleteList(userList)
		}
	}
	
	var body: some View {
		HStack {
			if userLists.isEmpty {
				VStack {
					Spacer()					
				}
			} else {
				VStack {
					List(userLists) { userList in
						NavigationLink(value: userList) {
							VStack {
								ListCellView(
									userList: userList,
									onEvent: { event in
										handleOnEvent(event)
									}
								)
								
							}
						}
					}.navigationDestination(for: UserList.self) { userList in
						ListDetailView(userList: userList)
						
					}
					
				}
				
			}
			
		}
	}
}

