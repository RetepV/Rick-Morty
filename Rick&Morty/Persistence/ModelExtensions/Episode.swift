//
//  Episode.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 17-05-2025.
//

import Foundation
import CoreData

extension Episode {
    
    // MARK: - Convenience

    enum Attributes: String {
        case airDate = "airDate"
        case episodeCode = "episodeCode"
        case id = "id"
        case name = "name"
        case recordState = "recordState"
    }
    
    enum Relationships: String {
        case characters = "characters"
    }
    
    var formattedAirDate: String? {
        
        guard let airDate else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: airDate)
    }
    
    var charactersArray: [Character] {
        let charactersSet = self.characters as? Set<Character> ?? []
        return Array(charactersSet).sorted { $0.id < $1.id }
    }
    
    // MARK: Comparing
    
    func hasDifferences(model: EpisodeAPIModel) -> Bool {
        
        return (self.name != model.name ||
                self.airDate != model.airDateAsDate ||
                self.episodeCode != model.episodeCode)
    }
    
    // MARK: Record updates from models.
    
    func update(model: EpisodeAPIModel) throws {
        
        self.id = model.id
        self.name = model.name
        self.airDate = model.airDateAsDate
        self.episodeCode = model.episodeCode
        
        try self.updateCharacters(model: model)
        
        self.recordState = APIRecordState.upToDate.rawValue
    }
    
    func updateCharacters(model: EpisodeAPIModel) throws {
        
        guard let viewContext = self.managedObjectContext else {
            return
        }
        
        if let characterObjects = self.characters {
            self.removeFromCharacters(characterObjects)
        }
        
        guard let charactersURLStrings = model.characters else {
            // Nothing more to do.
            return
        }
        
        for characterURLString in charactersURLStrings {
            
            if let characterURL = URL(string: characterURLString),
               let characterID = Int64(characterURL.lastPathComponent) {
                
                let request = NSFetchRequest<Character>(entityName: "Character")
                request.predicate = NSPredicate(format: "%K == %d", Character.Attributes.id.rawValue, characterID)

                if let existingCharacterObject = try viewContext.fetch(request).first {
                    self.addToCharacters(existingCharacterObject)
                }
                else {
                    let newCharacterObject = Character(context: viewContext)
                    // We don't have the data here. So we add a placeholder and will update it in the background later.
                    newCharacterObject.id = characterID
                    
                    newCharacterObject.recordState = APIRecordState.placeHolder.rawValue

                    self.addToCharacters(newCharacterObject)
                }
            }
        }
    }
}
