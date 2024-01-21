//
//  PreviewData.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 18/1/24.
//

import Foundation
import CoreData

class PreviewData {
    static var userList: UserList {
        let viewContext = CoreDataProvider.shared.persistentContainer.viewContext
        let request = UserList.fetchRequest()
        return (try? viewContext.fetch(request).first) ?? UserList()
    }
    
    static var userLists: [UserList] {
        let viewContext = CoreDataProvider.shared.persistentContainer.viewContext
        let request = UserList.fetchRequest()
        return (try? viewContext.fetch(request)) ?? [UserList(context: viewContext)]
    }
    
    static var todo: TodoItem {
        let viewContext = CoreDataProvider.shared.persistentContainer.viewContext
        let request = TodoItem.fetchRequest()
        return (try? viewContext.fetch(request).last) ?? TodoItem(context: viewContext)
    }
    
}
