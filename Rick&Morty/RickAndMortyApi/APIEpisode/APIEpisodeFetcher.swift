//
//  APIEpisodeFetcher.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 18-05-2025.
//

import Foundation
import CoreData

struct APIEpisodeFetcher {
    
    // MARK: - Constants
    
    private let episodeUrlString = "episode"

    // MARK: - Private properties
    
    var baseURL: URL
    
    // MARK: - Lifecycle
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - Public functions
    
    // The list of episodes is retrieved in pages of 20 episode. If the url is nil,
    // then the first page is returned. And it will give the url for the next fetch.
    func fetchEpisodeList(url: URL?) async throws -> EpisodeListAPIModel? {
        
        var request = URLRequest(url: episodesUrl(url: url))
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try checkResponseForErrors(response: response as? HTTPURLResponse)
        
        var episodeList: EpisodeListAPIModel? = nil
        
        do {
            episodeList = try JSONDecoder().decode(EpisodeListAPIModel.self, from: data)
        }
        catch {
            throw APIError.decodeJSONFailed(error: error)
        }
        
        return episodeList
    }

    // MARK: - Private functions
    
    private func checkResponseForErrors(response: HTTPURLResponse?) throws {
        guard let response else {
            throw APIError.noResponseFromServer
        }
        guard response.statusCode == 200 else {
            throw APIError.fetchingDataFailed(httpStatusCode: response.statusCode)
        }
    }

    private func episodesUrl(url: URL?) -> URL {

        return url ?? baseURL.appending(component: episodeUrlString, directoryHint: .notDirectory)
    }

}
