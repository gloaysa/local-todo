
//
//  AddNewListView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 17/1/24.
//

import SwiftUI

struct ListCreateView: View {
	
	@Environment(\.dismiss) private var dismiss
	
	let userList: UserList?
	let onDismiss: () -> Void
	let onSave: (_ name: String, _ color: Color) -> Void
	
	@State private var name: String = ""
	@State private var selectedColor: Color = .yellow
	
	@State private var listName: String = ""
	@FocusState private var isFocused: Bool
	
	
	private var isFormValid: Bool {
		!name.isEmptyOrWhitespace
	}
	
	var body: some View {
		VStack {
			VStack {
				Image(systemName: "line.3.horizontal.circle.fill")
					.foregroundColor(selectedColor)
					.font(.system(size: 100))
				TextField("List Name", text: $name)
					.multilineTextAlignment(.center)
					.textFieldStyle(.roundedBorder)
					.focused($isFocused)
			}
			.padding(30)
			.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
			
			
			ColorPickerView(selectedColor: $selectedColor)
			
			Spacer()
		}
		.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
		.onAppear {
			isFocused = true
			selectedColor = userList?.color ?? Color(.blue)
			name = userList?.name ?? ""
			listName = name.isEmpty ? "New List" : "List info"
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text(listName)
					.font(.headline)
			}
			
			ToolbarItem(placement: .navigationBarLeading) {
				Button("Close") {
					onDismiss()
					dismiss()
				}
			}
			
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("Done") {
					userList?.name = name
					userList?.color = selectedColor
					onSave(name, selectedColor)
					
					dismiss()
				}.disabled(!isFormValid)
			}
		}
	}
}

#Preview {
	NavigationView {
		ListCreateView(
			userList: PreviewData.userList,
			onDismiss: {}
		) { name, color in }
	}
	
}
