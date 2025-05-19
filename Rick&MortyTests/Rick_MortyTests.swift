//
//  Rick_MortyTests.swift
//  Rick&MortyTests
//
//  Created by Peter de Vroomen on 16-05-2025.
//

import Foundation
import SwiftUI
import Testing
@testable import Rick_Morty

struct Rick_MortyTests {
    
    let apiBaseURL: URL = URL(string: "https://rickandmortyapi.com/api/")!
    

    @Test func testBasicCharacterAPI() async throws {
        
        var persistenceController: PersistenceController?
        await withCheckedContinuation { continuation in
            persistenceController = PersistenceController(containerName: "Rick_Morty", inMemory: true) {
                continuation.resume()
            }
        }
        #expect(persistenceController != nil)

        let apiCharacterHandler = APICharacterHandler(baseURL: apiBaseURL, persistenceController: persistenceController!)
        
        var characterInfo: CharacterAPIModel?
        
        characterInfo = try await apiCharacterHandler.apiCharacterFetcher.fetchCharacterInfo(id: 1)
        
        #expect(characterInfo != nil)
        
        #expect(characterInfo?.name == "Rick Sanchez")
        #expect(characterInfo?.status == "Alive")
        #expect(characterInfo?.species == "Human")
        
        #expect(characterInfo?.origin?.name == "Earth (C-137)")
        #expect(characterInfo?.episodeUrls?.count == 51)
        
        characterInfo = try await apiCharacterHandler.apiCharacterFetcher.fetchCharacterInfo(id: 2)
        
        #expect(characterInfo != nil)
        
        #expect(characterInfo?.name != "Rick Sanchez")
        
        characterInfo = try await apiCharacterHandler.apiCharacterFetcher.fetchCharacterInfo(id: 183)
        
        #expect(characterInfo != nil)
        
        #expect(characterInfo?.name == "Johnny Depp")
        
        #expect(characterInfo?.status == "Alive")
        #expect(characterInfo?.species == "Human")
        
        #expect(characterInfo?.origin?.name == "Earth (C-500A)")
    }
    
    @Test func testExtendedCharacterAPI() async throws {
        
        var persistenceController: PersistenceController?
        await withCheckedContinuation { continuation in
            persistenceController = PersistenceController(containerName: "Rick_Morty", inMemory: true) {
                continuation.resume()
            }
        }
        #expect(persistenceController != nil)

        let apiCharacterHandler = APICharacterHandler(baseURL: apiBaseURL, persistenceController: persistenceController!)
        
        var characterInfo: CharacterAPIModel?
        
        characterInfo = try await apiCharacterHandler.apiCharacterFetcher.fetchCharacterInfo(id: 1)
        
        // Test if fetch went alright.

        #expect(characterInfo?.name == "Rick Sanchez")
        #expect(characterInfo?.status == "Alive")
        #expect(characterInfo?.species == "Human")
        
        #expect(characterInfo?.origin?.name == "Earth (C-137)")
        #expect(characterInfo?.episodeUrls?.count == 51)

        // TODO: Can't get these to work for now, getting error.
        //
        // error: No NSEntityDescriptions in any model claim the NSManagedObject subclass 'Character' so +entity is confused.  Have you loaded your NSManagedObjectModel yet ?
        //
        // Is it because two NSPersistentContainers with the same mom are created when the test target runs? One in Rick_MortyApp and one here.
        // I guess we have to switch to using mocks, but too much work for now.
                
        // Persist in database.
        try await apiCharacterHandler.apiCharacterPersister.persistCharacter(characterModel: #require(characterInfo))
        // Read back from database
        let characterObject = try await apiCharacterHandler.apiCharacterPersister.fetchCharacterByID(1)
        
        #expect(characterObject?.id == 1)
        #expect(characterObject?.name == "Rick Sanchez")
        #expect(characterObject?.status == "Alive")
        #expect(characterObject?.species == "Human")
        
        #expect(characterObject?.origin?.name == "Earth (C-137)")
        #expect(characterObject?.episodes?.count == 51)
    }

    
    @Test func testBasicEpisodeAPI() async throws {
        
        var persistenceController: PersistenceController?
        await withCheckedContinuation { continuation in
            persistenceController = PersistenceController(containerName: "Rick_Morty", inMemory: true) {
                continuation.resume()
            }
        }
        #expect(persistenceController != nil)

        let apiEpisodeHandler = APIEpisodeHandler(baseURL: apiBaseURL, persistenceController: persistenceController!)
        
        var episodeInfo: EpisodeListAPIModel?
        
        episodeInfo = try await apiEpisodeHandler.apiEpisodeFetcher.fetchEpisodeList(url: nil)
        
        #expect(episodeInfo != nil)
        #expect(episodeInfo?.info != nil)

        #expect(episodeInfo!.info!.count != nil)
        #expect(episodeInfo!.info!.count! > 40)
        
        #expect(episodeInfo!.info!.nextFetchURL != nil)
        #expect(episodeInfo!.info!.nextFetchURL!.count > 0)

        #expect(episodeInfo!.results != nil)

        #expect(episodeInfo!.results!.count > 0)
        #expect(episodeInfo!.results!.count <= 20)

        #expect(episodeInfo!.results!.first != nil)
        #expect(episodeInfo!.results!.first!.id == 1)
        #expect(episodeInfo!.results!.first!.name == "Pilot")
    }
    
    @Test func testNextEpisodeAPI() async throws {
        
        var persistenceController: PersistenceController?
        await withCheckedContinuation { continuation in
            persistenceController = PersistenceController(containerName: "Rick_Morty", inMemory: true) {
                continuation.resume()
            }
        }
        #expect(persistenceController != nil)

        let apiEpisodeHandler = APIEpisodeHandler(baseURL: apiBaseURL, persistenceController: persistenceController!)
        
        var episodeInfo: EpisodeListAPIModel?
        
        episodeInfo = try await apiEpisodeHandler.apiEpisodeFetcher.fetchEpisodeList(url: nil)
        
        #expect(episodeInfo != nil)
        #expect(episodeInfo!.info != nil)
        
        #expect(episodeInfo!.results != nil)
        
        #expect(episodeInfo!.results!.count > 0)
        #expect(episodeInfo!.results!.count <= 20)
        
        #expect(episodeInfo!.results!.first != nil)
        #expect(episodeInfo!.results!.first!.id == 1)
        #expect(episodeInfo!.results!.first!.name == "Pilot")
        
        #expect(episodeInfo!.info!.nextFetchURL != nil)
        #expect(episodeInfo!.info!.nextFetchURL!.count > 0)
        
        let nextURL = URL(string: episodeInfo!.info!.nextFetchURL!)!
        let nextExpectedFirstEpisodeID = episodeInfo!.results!.first!.id + Int64(episodeInfo!.results!.count)
        
        episodeInfo = try await apiEpisodeHandler.apiEpisodeFetcher.fetchEpisodeList(url: nextURL)
        
        #expect(episodeInfo != nil)
        #expect(episodeInfo!.info != nil)
        
        #expect(episodeInfo!.results != nil)
        
        #expect(episodeInfo!.results!.count > 0)
        #expect(episodeInfo!.results!.count <= 20)
        
        #expect(episodeInfo!.results!.first != nil)
        #expect(episodeInfo!.results!.first!.id == nextExpectedFirstEpisodeID)
    }
    
    @Test func testURLCache() async throws {
        
        let imageURL = URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!
        
        let characterImage = await CachedImageStorage.downloadImage(url: imageURL)
        
        #expect(characterImage != nil)
        #expect(characterImage!.size.equalTo(CGSize(width: 300, height: 300)))

        let cachedResponse = URLCache.shared.cachedResponse(for: .init(url: imageURL))
        
        #expect(cachedResponse != nil)
        #expect(cachedResponse?.data != nil)

        let cachedImage = UIImage(data: cachedResponse!.data)
        
        #expect(cachedImage != nil)
        #expect(cachedImage!.size.equalTo(CGSize(width: 300, height: 300)))
    }
}
