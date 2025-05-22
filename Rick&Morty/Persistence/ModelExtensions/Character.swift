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
    
    static let entityName: String = "Character"
    
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
        
        try self.updateOrigin(originModel: model.origin)
        try self.updateEpisodes(episodeURLStrings: model.episodeUrls)
        
        self.recordState = APIRecordState.upToDate.rawValue
    }
    
    func updateOrigin(originModel: CharacterAPIModel.Origin?) throws {
        
        guard let viewContext = self.managedObjectContext else {
            return
        }
        
        self.origin = nil
        
        guard let originModel, let originName = originModel.name else {
            // Done, if there is no new origin to set, or if the model doesn't even have a name.
            return
        }
        
        let request = NSFetchRequest<Origin>(entityName: Origin.entityName)
        request.predicate = NSPredicate(format: "%K == %@", Origin.Attributes.name.rawValue, originName)

        if let existingOriginObject = try viewContext.fetch(request).first {
            self.origin = existingOriginObject
        }
        else {
            let newOriginObject = Origin(context: viewContext)
            
            newOriginObject.update(model: originModel)

            self.origin = newOriginObject
        }
    }
    
    func updateEpisodes(episodeURLStrings: [String]?) throws {
        
        guard let viewContext = self.managedObjectContext else {
            return
        }
        
        for episodeURLString in episodeURLStrings ?? [] {
            
            guard let episodeIDString = episodeURLString.split(separator: "/").last,
                  let episodeID = Int64(episodeIDString) else {
                // Probably a malformed URL, just ignore it and continue with the next.
                continue
            }
            
            let request = NSFetchRequest<Episode>(entityName: Episode.entityName)
            request.predicate = NSPredicate(format: "%K == %d", Episode.Attributes.id.rawValue, episodeID)

            if let existingEpisodeObject = try viewContext.fetch(request).first {
                self.addToEpisodes(existingEpisodeObject)
            }
            else {
                // Do nothing. The Episode is not in the database (yet). We could choose to fetch the episode now,
                // but that will make for complex code, as we have to check if we need to resolve for other Character
                // entities as well.
                // Instead of that complex code, we make sure to download all Episode entities first, and only then
                // download the Characters. So all should be resolved (unless a Character references an Episode that
                // does not exist in the remote). As we update from the remote regularly, anything missing will be
                // resolved in a future update anyway.
            }
        }
    }
}
