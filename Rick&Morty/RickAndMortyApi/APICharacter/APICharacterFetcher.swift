//
//  APICharacterFetcher.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 17-05-2025.
//

import Foundation

struct APICharacterFetcher {
    
    // MARK: - Constants
    
    private let characterUrlString = "character"

    // MARK: - Private properties
    
    var baseURL: URL
    
    // MARK: - Lifecycle
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - Public functions
    
    func fetchCharacterInfo(id: Int64) async throws -> CharacterAPIModel? {
        
        var request = URLRequest(url: characterUrl(id: id))
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        try checkResponseForErrors(response: response as? HTTPURLResponse)
        
        guard data.count > 0 else {
            throw APIError.noDataFound(info: "Expected data, but none received")
        }

        var character: CharacterAPIModel? = nil
        do {
            character = try JSONDecoder().decode(CharacterAPIModel.self, from: data)
        }
        catch {
            throw APIError.decodeJSONFailed(error: error)
        }
        
        return character
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
    
    private func characterUrl(id: Int64) -> URL {
        return baseURL
            .appending(path: characterUrlString, directoryHint: .isDirectory)
            .appending(path: String(id), directoryHint: .notDirectory)
    }
}
