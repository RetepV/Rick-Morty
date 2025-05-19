//
//  Origin.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 18-05-2025.
//

import Foundation

extension Origin {
    
    // MARK: - Convenience
    
    static let entityName: String = "Origin"

    enum Attributes: String {
        case name = "name"
        case recordState = "recordState"
        case url = "url"
    }
    
    enum Relationships: String {
        case characters = "characters"
    }
    
    // MARK: - Public functions
    
    // MARK: Comparing
    
    func hasDifferences(model: CharacterAPIModel.Origin) -> Bool {
        
        return (self.name != model.name ||
                self.url != model.url)
    }
    
    // MARK: Record updates from models.
    
    func update(model: CharacterAPIModel.Origin) {
        
        self.name = model.name
        self.url = model.url
        
        self.recordState = APIRecordState.upToDate.rawValue
    }
}
