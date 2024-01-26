//
//  UserListCellView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import SwiftUI

enum ListCellEvents {
	case onEdit(UserList)
	case onDelete(UserList)
}

struct ListCellView: View {
	let userList: UserList
	let onEvent: (ListCellEvents) -> Void
	
	@State private var appears: Bool = false
	@State private var openDetails: Bool = false
	
	var listCreateView: some View {
		HStack {
			NavigationStack {
				ListCreateView(
					userList: userList,
					onDismiss: {}
				) { name, color in
					userList.name = name
					userList.color = color
					onEvent(ListCellEvents.onEdit(userList))
				}
			}
		}
	}
	
	var body: some View {
		HStack {
			Button ("", systemImage: "line.3.horizontal.circle.fill") {
			}
			.padding(.trailing, -15.0)
			.padding(.leading, -10.0)
			.symbolEffect(.bounce.down, value: appears)
			.foregroundColor(userList.color)
			.font(.title2)
			
			VStack {
				Text(userList.name!)
					.font(.title3)
					.fontWeight(.light)
			}
		}
		.sheet(isPresented: $openDetails, onDismiss: {}) {
			listCreateView
		}
		.onAppear {
			appears = true
		}
		.swipeActions {
			Button("Details", systemImage: "info.circle.fill") {
				openDetails = true
			}
			
			Button("Delete", systemImage: "trash.fill", role: .destructive) {
				onEvent(ListCellEvents.onDelete(userList))
			}
		}
	}
}

#Preview {
	ListCellView(
		userList: PreviewData.userList,
		onEvent: { event in
			print(event)
		}
	)
}

