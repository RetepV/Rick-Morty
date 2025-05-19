//
//  RickAndMortyApiManager.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//

import Foundation
import CoreData

final
class RickAndMortyApiManager : ObservableObject {
    
    // MARK: - Constants
    
    private let apiBaseURL: URL = URL(string: "https://rickandmortyapi.com/api/")!
    
    private let characterUrlString = "character"
    
    private let episodeHandler: APIEpisodeHandler
    private let characterHandler: APICharacterHandler

    // MARK: - Private properties
    
    private let persistenceController: PersistenceController

    // MARK: - Lifecycle
    
    init(persistenceController: PersistenceController) {

        self.persistenceController = persistenceController
        
        self.episodeHandler = APIEpisodeHandler(baseURL: apiBaseURL, persistenceController: persistenceController)
        self.characterHandler = APICharacterHandler(baseURL: apiBaseURL, persistenceController: persistenceController)
    }
    
    // MARK: - Public functions
    
    func refreshAllCharacters() {
        characterHandler.refreshAllCharacters()
    }

    func updateEpisodeList(completed: @escaping ()->()) {
        
        episodeHandler.updateFullEpisodeList(pageCompleted: {
            
        }, allCompleted: {
            self.characterHandler.updatePlaceholders()
            ApplicationStateStorage.setEpisodesLastUpdated(Date())
            completed()
        })
    }
}
