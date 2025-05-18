//
//  Rick_MortyApp.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//

import SwiftUI

@main
struct Rick_MortyApp: App {
    
    let persistenceController: PersistenceController
    let rickAndMortyApiManager: RickAndMortyApiManager
    
    init() {
        persistenceController = PersistenceController(containerName: "Rick_Morty", inMemory: false)
        rickAndMortyApiManager = RickAndMortyApiManager(persistenceController: persistenceController)
        
        loadRocketSimConnect()
    }
    
    var body: some Scene {
        
        WindowGroup {
            EpisodeListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(rickAndMortyApiManager)
        }
    }

    // MARK: - Private functions
    
    private func loadRocketSimConnect() {
#if DEBUG
        guard (Bundle(path: "/Applications/Development/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true) else {
            print("Failed to load linker framework")
            return
        }
        print("RocketSim Connect successfully linked")
#endif
    }
}
