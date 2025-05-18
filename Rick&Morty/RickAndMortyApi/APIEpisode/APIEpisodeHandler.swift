//
//  APIEpisodeHandler.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 18-05-2025.
//

import Foundation
import CoreData

struct APIEpisodeHandler {
    
    // MARK: - Private properties
    
    let apiEpisodeFetcher: APIEpisodeFetcher
    let apiEpisodePersister: APIEpisodePersister

    // MARK: - Lifecycle
    
    init(baseURL: URL, persistenceController: PersistenceController) {
        self.apiEpisodeFetcher = APIEpisodeFetcher(baseURL: baseURL)
        self.apiEpisodePersister = APIEpisodePersister(persistenceController: persistenceController)
    }
    
    // MARK: - Public functions
    
    func updateFullEpisodeList(pageCompleted: @escaping ()->(), allCompleted: @escaping ()->()) {
        
        Task {
            
            if let firstEpisodes = try await apiEpisodeFetcher.fetchEpisodeList(url: nil) {
                
                try await apiEpisodePersister.persistEpisodeList(model: firstEpisodes)
                
                await MainActor.run {
                    pageCompleted()
                }
                
                guard let info = firstEpisodes.info else {
                    throw APIError.noDataFound(info: "No info found while fetching first page, cannot continue.")
                }
                
                if let nextFetchURL = info.nextFetchURL.flatMap(URL.init(string:)) {
                    continueUpdatingFullEpisodeList(url: nextFetchURL, pageCompleted: pageCompleted, allCompleted: allCompleted)
                }
            }
            else {
                throw APIError.noDataFound(info: "No data found while fetching first episodes.")
            }
        }
    }
    
    // MARK: - Private functions
    
    private func continueUpdatingFullEpisodeList(url: URL, pageCompleted: @escaping ()->(), allCompleted: @escaping ()->()) {
        
        Task {
            
            if let moreEpisodes = try await apiEpisodeFetcher.fetchEpisodeList(url: url) {
            
                try await apiEpisodePersister.persistEpisodeList(model: moreEpisodes)
                
                await MainActor.run {
                    pageCompleted()
                }
                
                guard let info = moreEpisodes.info else {
                    throw APIError.noDataFound(info: "No info found while fetching more pages, cannot continue.")
                }
                
                if let nextFetchURL = info.nextFetchURL.flatMap(URL.init(string:)) {
                    continueUpdatingFullEpisodeList(url: nextFetchURL, pageCompleted: pageCompleted, allCompleted: allCompleted)
                }
                else {
                    await MainActor.run {
                        allCompleted()
                    }
                }
            }
            else {
                throw APIError.noDataFound(info: "No data found while fetching episodes with url \(url).")
            }
        }
    }
}
