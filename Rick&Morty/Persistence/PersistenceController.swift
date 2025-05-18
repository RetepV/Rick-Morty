//
//  Persistence.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//

import CoreData

struct PersistenceController {
    
    // MARK: - Public properties
    
    // static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        
        let result = PersistenceController(containerName: "Rick_Morty", inMemory: true)
        
        let viewContext = result.container.viewContext
        
        for episodePreviewData in PersistencePreviewData.episodes {
            let newEpisode = Episode(context: viewContext)
            newEpisode.id = episodePreviewData.id
            newEpisode.name = episodePreviewData.name
            newEpisode.airDate = episodePreviewData.airDateAsDate
            newEpisode.episodeCode = episodePreviewData.episodeCode
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    // MARK: - Lifecycle
    
    let container: NSPersistentContainer

    init(containerName: String, inMemory: Bool = false, completed: (() -> Void)? = nil) {
        
        container = NSPersistentContainer(name: containerName)
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
            
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
            }
            
            if let completed {
                
                completed()
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
