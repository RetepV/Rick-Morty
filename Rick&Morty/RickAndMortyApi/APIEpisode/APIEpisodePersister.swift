//
//  APIEpisodePersister.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 18-05-2025.
//

import Foundation
import CoreData

struct APIEpisodePersister {
    
    // MARK: - Constants
    
    private let episodeUrlString = "episode"

    // MARK: - Private properties
    
    var persistenceController: PersistenceController
    
    // MARK: - Lifecycle
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    // MARK: - Public functions
    
    @MainActor
    func persistEpisodeList(model: EpisodeListAPIModel) async throws {
        
        guard let episodeModelList = model.results else {
            // Nothing to process.
            return
        }
        
        let viewContext = persistenceController.container.newBackgroundContext()
        
        async let _ = try await viewContext.perform {
            
            for episodeModel in episodeModelList {
                
                let request = NSFetchRequest<Episode>(entityName: "Episode")
                request.predicate = NSPredicate(format: "%K == %d", Episode.Attributes.id.rawValue, episodeModel.id)
                
                if let existingEpisodeObject = try viewContext.fetch(request).first {

                    if existingEpisodeObject.hasDifferences(model: episodeModel) {
                        
                        try existingEpisodeObject.update(model: episodeModel)
                    }
                }
                else {

                    let newEpisodeObject = Episode(context: viewContext)
                    try newEpisodeObject.update(model: episodeModel)
                }
            }
            
            try? viewContext.save()
        }
    }
}
