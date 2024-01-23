//
//  SelectListView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import SwiftUI

struct ListPickerView: View {
	
	@FetchRequest(sortDescriptors: [])
	private var userListsFetchResults: FetchedResults<UserList>
	
	@Binding var selectedList: UserList?
	
	var body: some View {
		List(userListsFetchResults) { userList in
			HStack {
				HStack {
					Image(systemName: "line.3.horizontal.circle.fill")
						.foregroundColor(userList.color)
					Text(userList.name!)
				}
				.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
				.contentShape(Rectangle())
				.onTapGesture{
					selectedList = userList
				}
				
				Spacer()
				
				if selectedList == userList {
					Image(systemName: "checkmark")
						.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
				}
			}
		}
	}
}

#Preview {
	ListPickerView(selectedList: .constant(PreviewData.userList))
		.environment(
			\.managedObjectContext,
			 CoreDataProvider.shared.persistentContainer.viewContext
		)
}
