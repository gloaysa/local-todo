import Foundation
import CoreData

/// Represents different types of todos for filtering purposes.
enum TodoItemStatType {
    case today
    case all
    case scheduled
    case completed
}

/// `TodoItemService` provides functionality related to managing todos using Core Data.
class TodoItemService {
    
    /// The view context for Core Data operations.
    private static var viewContext: NSManagedObjectContext {
        CoreDataProvider.shared.persistentContainer.viewContext
    }
    
    /// Saves changes made to the Core Data context.
    /// - Throws: An error if the save operation fails.
    private static func save() throws {
        if viewContext.hasChanges {
            print("[TodoItemService]: saving context", viewContext.insertedObjects.debugDescription)
            try viewContext.save()
        }
    }
    
    /// Retrieves todos not marked as completed for a specific user list.
    /// - Parameter userList: The user list for which to retrieve todos.
    /// - Returns: A fetch request for todos not completed for the specified user list.
    static func getTodoItemsNotDoneByList(userList: UserList) -> NSFetchRequest<TodoItem> {
        let request = TodoItem.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "userList = %@ AND status = false", userList)
        return request
    }
    
    /// Retrieves todos based on a search query.
    /// - Parameter search: The search query.
    /// - Returns: A fetch request for todos containing the search query in the title.
    static func getTodoItemsBySearch(_ search: String) -> NSFetchRequest<TodoItem> {
        let request = TodoItem.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "summary CONTAINS[cd] %@", search)
        return request
    }
    
    /// Retrieves todos based on the specified `TodoItemStatType`.
    /// - Parameter statType: The type of todos to retrieve.
    /// - Returns: A fetch request for todos based on the specified type.
    static func todosByStatType(statType: TodoItemStatType) -> NSFetchRequest<TodoItem> {
        let request = TodoItem.fetchRequest()
        request.sortDescriptors = []
        switch statType {
        case .all:
            request.predicate = NSPredicate(format: "status = false")
        case .today:
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            request.predicate = NSPredicate(format: "((dueDate >= %@) AND (dueDate < %@)) OR ((dueDate = nil) AND (dueTime != nil))", today as NSDate, tomorrow! as NSDate)
        case .scheduled:
            request.predicate = NSPredicate(format: "(dueDate != nil OR dueTime != nil) AND status = false")
        case .completed:
            request.predicate = NSPredicate(format: "status = true")
        }
        return request
    }
    
    /// Creates a new todo for a specified user list with the provided configuration.
    /// - Parameters:
    ///   - userList: The user list for which to create the todo.
    ///   - createConfig: The configuration for creating the todo.
    /// - Throws: An error if the creation or save operation fails.
    static func createTodoItem(userList: UserList, createConfig: TodoItemCreateDTO) throws {
        let todoToCreate = TodoItem(context: viewContext)
        todoToCreate.userList = userList
        todoToCreate.status = createConfig.status
        todoToCreate.summary = createConfig.summary
        todoToCreate.notes = createConfig.notes
        todoToCreate.dueDate = createConfig.dueDate
        todoToCreate.dueTime = createConfig.dueTime
        
        // userList.addToTodos(todoToCreate)
        
        try save()
        
        let todoId = todoToCreate.objectID.uriRepresentation().absoluteString
        print("[TodoItemService]: creating a todo", todoId)
        
        if todoToCreate.dueDate != nil || todoToCreate.dueTime != nil {
            NotificationService.scheduleNotification(notificationData: todoToCreate)
        }
    }
    
    /// Updates an existing todo with the provided edit configuration.
    /// - Parameters:
    ///   - todo: The todo to update.
    ///   - editConfig: The edit configuration for updating the todo.
    /// - Throws: An error if the update or save operation fails.
    static func updateTodoItem(todo: TodoItem, updated: TodoItemUpdateDTO) throws {
        let previousVersion = TodoItemDateAndTime(date: todo.dueDate, time: todo.dueTime)
        todo.status = updated.status
        todo.summary = updated.summary
        todo.notes = updated.notes
        todo.dueDate = updated.dueDate
        todo.dueTime = updated.dueTime
        
        try save()
        
        // Update notifications based on changes
        updateNotificationsForTodoItemChange(previousVersion: previousVersion, updatedVersion: todo)
    }
    
    /// Updates the title of an existing todo.
    /// - Parameters:
    ///   - todo: The todo to update.
    ///   - newTitle: The new title for the todo.
    /// - Throws: An error if the update operation fails.
    static func updateTodoItemTitle(todo: TodoItem, newTitle: String) throws {
        var todoConfig = TodoItemUpdateDTO()
        todoConfig.dueDate = todo.dueDate
        todoConfig.dueTime = todo.dueTime
        todoConfig.status = todo.status
        todoConfig.notes = todo.notes
        todoConfig.summary = newTitle
        
        try updateTodoItem(todo: todo, updated: todoConfig)
    }
    
    /// Updates the note of an existing todo.
    /// - Parameters:
    ///   - todo: The todo to update.
    ///   - newNote: The new note for the todo.
    /// - Throws: An error if the update operation fails.
    static func updateTodoItemNote(todo: TodoItem, newNote: String) throws {
        var todoConfig = TodoItemUpdateDTO()
        todoConfig.dueDate = todo.dueDate
        todoConfig.dueTime = todo.dueTime
        todoConfig.status = todo.status
        todoConfig.summary = todo.summary ?? ""
        todoConfig.notes = newNote
        
        try updateTodoItem(todo: todo, updated: todoConfig)
    }
    
    /// Deletes an existing todo and associated notification.
    /// - Parameter todo: The todo to delete.
    /// - Throws: An error if the deletion operation fails.
    static func deleteTodoItem(todo: TodoItem) throws {
        let todoId = todo.objectID.uriRepresentation().absoluteString
        let dueDate = todo.dueDate
        let dueTime = todo.dueTime
                
        viewContext.delete(todo)
        try save()
        
        // Delete associated notification if exists
        if (dueDate != nil || dueTime != nil) {
            NotificationService.deleteNotification(identifier: todoId)
        }
    }
    
    /// Updates notifications based on changes in a todo.
    /// - Parameters:
    ///   - previousVersion: The original todo.
    ///   - updatedVersion: The updated todo DTO.
    private static func updateNotificationsForTodoItemChange(previousVersion: TodoItemDateAndTime, updatedVersion: TodoItem) {
        let todoId = updatedVersion.objectID.uriRepresentation().absoluteString

        // previousVersion HAS notification
        if previousVersion.dueDate != nil || previousVersion.dueTime != nil {
            //previousVersion HAS notification AND updatedVersion HAS: EDIT
            if updatedVersion.dueDate != nil || updatedVersion.dueTime != nil {
                NotificationService.editNotification(todoId: todoId, newTodo: updatedVersion)
            }
            
            // previousVersion HAS notification, updatedVersion NO: DELETE
            if updatedVersion.dueDate == nil && updatedVersion.dueTime == nil {
                NotificationService.deleteNotification(identifier: todoId)
            }
            
            // previousVersion NOT notification
        } else if previousVersion.dueDate == nil && previousVersion.dueTime == nil {
            // previousVersion NO notification, updatedVersion HAS: CREATE
            if updatedVersion.dueDate != nil || updatedVersion.dueTime != nil {
                NotificationService.scheduleNotification(notificationData: updatedVersion)
            }
            
            // OldTodoItem NO notification, newTodoItem NO: NOTHING TO DO
//            if updatedVersion.dueDate == nil && updatedVersion.dueTime == nil {
//                print("OldTodoItem NO notification, newTodoItem NO: NOTHING TO DO")
//            }
        }
    }
}
