//
//  UserListCellView.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import SwiftUI

enum ListCellEvents {
    case onDetails(UserList)
    case onDelete(UserList)
}

struct ListCellView: View {
    let userList: UserList
    let onEvent: (ListCellEvents) -> Void
    
    @State private var appears: Bool = false
    
    var body: some View {
        HStack {
            Button ("", systemImage: "line.3.horizontal.circle.fill") {
            }
            .symbolEffect(.bounce.down, value: appears)
            .foregroundColor(userList.color)
            
            VStack {
                Text(userList.name!)
            }
        }
        .onAppear {
            appears = true
        }
        .swipeActions {
            Button("Delete", role: .destructive) {
                onEvent(ListCellEvents.onDelete(userList))
            }
            
            Button("Details") {
                onEvent(ListCellEvents.onDetails(userList))
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

