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
    
    @State private var selectedList: UserList?
    @State private var showListDetail: Bool = false
    
    private func deleteReminder(_ userList: UserList) {
        do {
            try UserListService.deleteUserList(userList)
        } catch {
            print(error)
        }
    }
    
    private func selectedListIsNotNill() -> Bool {
        return selectedList !== nil
    }
    
    private func handleOnEvent(_ event: ListCellEvents) {
        switch event {
        case .onDetails(let userList):
            selectedList = userList
            showListDetail = true
        case .onDelete(let userList):
            deleteReminder(userList)
        }
    }
    
    var body: some View {
        HStack {

            if userLists.isEmpty {
                VStack {
                    Spacer()
                    
                    Button("add list") {
                        let temp = UserListService.getTemporalUserList()
                        temp.name = "My todo list"
                        do {
                            try UserListService.createUserList(temp)
                        } catch {
                            print(error)
                        }
                }
                
                }
                
                
            } else {
                VStack {
                    List {
                        ForEach(userLists) { userList in
                            NavigationLink(value: userList) {
                                VStack {
                                    ListCellView(
                                        userList: userList,
                                        onEvent: { event in
                                            handleOnEvent(event)
                                        }
                                    )
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                                    .padding([.leading], 10)
                                    .font(.title3)
                                    .foregroundColor(colorScheme == .dark ? Color.offWhite : Color.darkGray)
                                    
                                }
                            }
                            
                        }
                        
                    }
                    .navigationDestination(for: UserList.self) { userList in
                        ListDetailView(userList: userList)
                    }
                    .listStyle(.inset)
                    .sheet(
                        isPresented: $showListDetail,
                        onDismiss: {
                            print("dismissed")
                            selectedList = nil
                        }
                    ) {
                        if (selectedListIsNotNill()) {
                            NavigationStack {
                                ListCreateView(
                                    userList: selectedList!,
                                    onDismiss: { selectedList = nil}
                                ) { updateList in
                                    do {
                                        try UserListService.editUserList(userList: updateList)
                                    } catch {
                                        print(error)
                                    }
                                    
                                    
                                }
                            }
                            
                        } else {
                            // TODO: Properly handle this
                            NavigationViewError(errorMessage: "The List could not be selected")
                        }
                        
                    }
                }
                
            }
            
        }
    }
}

