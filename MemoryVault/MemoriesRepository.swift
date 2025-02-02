//
//  MemoriesDataManager.swift
//  MemoryVault
//
//  Created by Kaneis Zontanos on 2/2/25.
//

import Foundation
import CoreData

class MemoriesRepository {
    
    let container: NSPersistentContainer
    typealias Vault = [MemoryEntity]
    
    init() {
        container = NSPersistentContainer(name: "MemoryVault")
        container.loadPersistentStores { desc, err in
            if let error = err {
                print("ERROR CORE DATA \(error)")
            }
        }
    }
    
    func fetchMemories() -> Vault? {
        let request = NSFetchRequest<MemoryEntity>(entityName: "MemoryEntity")
        
        do {
            return try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR FETCHING \(error)")
        }
        
        return nil
    }
    
    func addMemory(id: UUID, title: String, content: String, sentiment: String, date: Date, image: String) {
        let newMemory = MemoryEntity(context: container.viewContext)
        
        newMemory.id = id
        newMemory.title = title
        newMemory.content = content
        newMemory.sentiment = sentiment
        newMemory.date = date
        newMemory.image = image
        
        saveMemoryVault()
    }
    
    func deleteMemory(withID id: UUID) {
        let request: NSFetchRequest<MemoryEntity> = MemoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
    }
    
    func saveMemoryVault() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("ERROR SAVING: \(error)")
        }
    }
}
