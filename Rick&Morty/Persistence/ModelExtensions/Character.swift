//
//  Character.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 17-05-2025.
//

import Foundation
import CoreData

extension Character {
    
    // MARK: - Convenience
    
    enum Attributes: String {
        case id = "id"
        case imageUrl = "imageUrl"
        case name = "name"
        case recordState = "recordState"
        case species = "species"
        case status = "status"
    }
    
    enum Relationships: String {
        case episodes = "episodes"
        case origin = "origin"
    }

    // MARK: - Public functions
    
    // MARK: Comparing
    
    func hasDifferences(model: CharacterAPIModel) -> Bool {
        
        return (self.name != model.name ||
                self.status != model.status ||
                self.species != model.species ||
                self.imageUrl != model.imageUrl)
    }
    
    // MARK: Record updates from models.
    
    func update(model: CharacterAPIModel) throws {

        self.id = model.id
        self.name = model.name
        self.status = model.status
        self.species = model.species
        self.imageUrl = model.imageUrl
        
        try self.updateOrigin(model: model.origin)
        
        self.recordState = APIRecordState.upToDate.rawValue
    }
    
    func updateOrigin(model: CharacterAPIModel.Origin?) throws {
        
        guard let viewContext = self.managedObjectContext else {
            return
        }
        
        self.origin = nil
        
        guard let model, let originName = model.name else {
            // Done, if there is no new origin to set, or the model doesn't even have a name..
            return
        }
        
        let request = NSFetchRequest<Origin>(entityName: "Origin")
        request.predicate = NSPredicate(format: "%K == %@", Origin.Attributes.name.rawValue, originName)

        if let existingOriginObject = try viewContext.fetch(request).first {
            self.origin = existingOriginObject
        }
        else {
            let newOriginObject = Origin(context: viewContext)
            
            newOriginObject.update(model: model)

            self.origin = newOriginObject
        }
    }
}
