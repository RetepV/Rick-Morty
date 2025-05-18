//
//  APICharacterHandler.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 18-05-2025.
//

import Foundation

struct APICharacterHandler {
    
    // MARK: - Private properties
    
    let apiCharacterFetcher: APICharacterFetcher
    let apiCharacterPersister: APICharacterPersister
    
    // MARK: - Lifecycle
    
    init(baseURL: URL, persistenceController: PersistenceController) {
        apiCharacterFetcher = APICharacterFetcher(baseURL: baseURL)
        apiCharacterPersister = APICharacterPersister(persistenceController: persistenceController)
    }
    
    // MARK: - Public functions
    
    func refreshAllCharacters() {
        
        Task {
            try await apiCharacterPersister.outdateAllCharacterRecords()
            
            updateOutdated()
        }
    }
    
    func updatePlaceholders() {
        Task {
            let characterIds = try await apiCharacterPersister.fetchCharacterIDsByRecordState(state: .placeHolder)
            for characterId in characterIds {
                if let characterModel = try await apiCharacterFetcher.fetchCharacterInfo(id: characterId) {
                    try await apiCharacterPersister.persistCharacter(characterModel: characterModel)
                }
            }
        }
    }

    func updateOutdated() {
        Task {
            let characterIds = try await apiCharacterPersister.fetchCharacterIDsByRecordState(state: .outDated)
            for characterId in characterIds {
                if let characterModel = try await apiCharacterFetcher.fetchCharacterInfo(id: characterId) {
                    try await apiCharacterPersister.persistCharacter(characterModel: characterModel)
                }
            }
        }
    }
}
