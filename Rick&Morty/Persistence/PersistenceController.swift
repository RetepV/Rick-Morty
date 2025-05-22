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

// NOTE: This extension is here to help disambiguate entities for Unit Tests. Without this extension, we will have the
//       following warnings when running Unit Tests, and also might have crashes in the tests because Core Data might
//       cast to the wrong entity class.
//
//       CoreData: warning: Multiple NSEntityDescriptions claim the NSManagedObject subclass 'Character' so +entity is unable to disambiguate.
//       CoreData: warning: Multiple NSEntityDescriptions claim the NSManagedObject subclass 'Character' so +entity is unable to disambiguate.
//       CoreData: warning:       'Character' (0x600003508160) from NSManagedObjectModel (0x6000021006e0) claims 'Character'.
//       CoreData: warning:       'Character' (0x600003508160) from NSManagedObjectModel (0x6000021006e0) claims 'Character'.
//       CoreData: warning:       'Character' (0x600003526d60) from NSManagedObjectModel (0x60000213d1d0) claims 'Character'.
//       CoreData: warning:       'Character' (0x600003526d60) from NSManagedObjectModel (0x60000213d1d0) claims 'Character'.
//
//       The reason is that when running Unit Tests, Xcode runs the app and the tests together. The app creates an instance of PersistenceController,
//       like usual. But in the Unit Tests, we create another instance of PersistenceControllerpersistent, except in-memory. They both use the same
//       object model, and this is confusing Core Data when trying to resolve entity descriptions.
//       A solution is to create a convenience initialiser for NSManagedObjectContext that specifically points to its provided NSManagedObjectContext
//       as the provider of the entity description.
//       This workaround works for the normal case and for Unit Tests, so we do not have to make a specific exceptions for the unit test. But do
//       understand that this is only necessary for working around the ambiguity issue when we run Unit Tests.

public extension NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }

}
