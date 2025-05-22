//
//  APICharacterPersister.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 18-05-2025.
//

import Foundation
import CoreData

struct APICharacterPersister {
    
    // MARK: - Private properties
    
    var persistenceController: PersistenceController
    
    // MARK: - Lifecycle
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    // MARK: - Public functions
    
    @MainActor
    func outdateAllCharacterRecords() async throws {
        
        let viewContext = persistenceController.container.newBackgroundContext()
        
        return try await viewContext.perform {
            
            let request = NSFetchRequest<Character>(entityName: Character.entityName)
            
            let characters = try viewContext.fetch(request)
            
            for character in characters {
                character.recordState = APIRecordState.outDated.rawValue
            }
            
            try? viewContext.save()
        }
    }
        
    @MainActor
    func fetchCharacterIDsByRecordState(state: APIRecordState) async throws -> [Int64] {
        
        let viewContext = persistenceController.container.newBackgroundContext()
        
        return try await viewContext.perform {
            
            let request = NSFetchRequest<Character>(entityName: Character.entityName)
            request.predicate = NSPredicate(format: "%K == %d", Character.Attributes.recordState.rawValue, state.rawValue)
            
            return try viewContext.fetch(request).compactMap(\.id)
        }
    }
    
    @MainActor
    func fetchCharacterByID(viewContext: NSManagedObjectContext, id: Int64) async throws -> Character? {
        
        let request = NSFetchRequest<Character>(entityName: Character.entityName)
        request.predicate = NSPredicate(format: "%K == %d", Character.Attributes.id.rawValue, id)
        request.returnsObjectsAsFaults = false
        
        let existingCharacterObject = try viewContext.fetch(request).first

        return existingCharacterObject
    }
        
    @MainActor
    func persistCharacter(characterModel: CharacterAPIModel) async throws {
        
        let viewContext = persistenceController.container.newBackgroundContext()
        
        async let _ = try await viewContext.perform {

            let request = NSFetchRequest<Character>(entityName: Character.entityName)
            request.predicate = NSPredicate(format: "%K == %d", Character.Attributes.id.rawValue, characterModel.id)

            if let existingCharacterObject = try viewContext.fetch(request).first {
                
                if existingCharacterObject.hasDifferences(model: characterModel) ||
                    existingCharacterObject.recordState == APIRecordState.outDated.rawValue {
                    
                    try existingCharacterObject.update(model: characterModel)
                }
            }
            else {
                
                let newCharacterObject = Character(context: viewContext)
                
                try newCharacterObject.update(model: characterModel)
            }
            
            try viewContext.save()
        }
    }
}
