//
//  UserListService.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 21/1/24.
//

import Foundation
import CoreData
import UIKit

class UserListService {
    
    /// The view context for Core Data operations.
    private static var viewContext: NSManagedObjectContext {
        CoreDataProvider.shared.persistentContainer.viewContext
    }
    
    /// Saves changes made to the Core Data context.
    /// - Throws: An error if the save operation fails.
    private static func save() throws {
        if viewContext.hasChanges {
            print("[UserListService]: Saving context", viewContext.insertedObjects.debugDescription)
            try viewContext.save()
        }
    }
    
    /// Retrieves or creates a temporary UserList entity in the given managed object context.
    ///
    /// - Returns: A temporary UserList entity. If there's an unsaved (inserted) UserList entity in the context, it is returned; otherwise, a new temporary UserList is created.
    static func getTemporalUserList() -> UserList {
        // Check for inserted (unsaved) objects in the viewContext
        let insertedUserLists = viewContext.insertedObjects.compactMap { $0 as? UserList }

        if let existingTempUserList = insertedUserLists.first {
            print("[UserListService]: Found existing temp:", existingTempUserList.objectID)
            return existingTempUserList
        } else {
            // Create a new temp UserList if none is found
            let tempUserList = UserList(context: viewContext)
            print("[UserListService]: Creating new temp:", tempUserList.objectID)
            tempUserList.name = ""
            //tempUserList.color = .yellow
            return tempUserList
        }
    }
    
    static func deleteTemporalUserList(_ userList: UserList) -> Void {
        print("[UserListService]: Deleting temp:", userList.objectID)
        viewContext.delete(userList)
    }
    
    /// Saves a new user list to Core Data.
    /// - Parameters:
    ///   - userList: A temporal UserList to be saved in the context.
    /// - Throws: An error if the save operation fails.
    static func createUserList(_ userList: UserList) throws {
        try save()
    }
    
    static func editUserList(userList: UserList) throws {
        try save()
    }
    
    static func deleteUserList(_ userList: UserList) throws {
        print("[UserListService]: Deleting userList:", userList.objectID)
        // TODO: handle batch deletion of notifications for each reminder inside the list
        viewContext.delete(userList)
        
        try save()
    }
    
}
