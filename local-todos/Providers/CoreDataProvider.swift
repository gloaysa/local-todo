//
//  CoreDataProvider.swift
//  local-todo
//
//  Created by Guillermo Loaysa on 17/1/24.
//

import Foundation
import CoreData

class CoreDataProvider {
    static let shared = CoreDataProvider();
    let persistentContainer: NSPersistentContainer
    
    private init() {
                
        persistentContainer = NSPersistentContainer(name: "TodoModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Error initializing TodoModel \(error)")
            }
        }
    }
}
