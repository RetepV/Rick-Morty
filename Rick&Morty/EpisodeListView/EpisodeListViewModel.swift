//
//  EpisodeListViewModel.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//
//

import Foundation
import SwiftUI

extension EpisodeListView {
        
    protocol ViewModelProtocol {
        
        var headerTitle: String {get}
        var headerSubtitle: String {get}

        var emptyListText: String {get}
        var endOfListText: String {get}

        var episodesLastUpdated: String {get}
        
        func episodeSelected(coordinator: SheetCoordinator<ViewModel.PresentableSheets>, id: Int64)
    }
    
    @Observable
    class ViewModel: ViewModelProtocol {
        
        // MARK: - Public
        
        var headerTitle: String { model.headerTitle }
        var headerSubtitle: String { model.headerSubtitle }
        
        var emptyListText: String { model.emptyListText }
        var endOfListText: String { model.endOfListText }

        var episodesLastUpdated: String { model.lastUpdateText(lastUpdated: ApplicationStateStorage.episodesLastUpdated) }
        
        func episodeSelected(coordinator: SheetCoordinator<ViewModel.PresentableSheets>, id: Int64) {
            Task {
                await coordinator.presentSheet(.characterListSheet(episodeId: id))
            }
        }
        
        // MARK: - Private
        
        private var model = EpisodeListModel()
        
        // MARK: - Presentable sheets
        
        enum PresentableSheets: Identifiable, SheetEnum {
            
            case characterListSheet(episodeId: Int64)
            
            var id: String {
                switch self {
                    case .characterListSheet(let episodeId): return "characterListSheet\(episodeId)"
                }
            }
            
            @ViewBuilder
            func view(coordinator: SheetCoordinator<ViewModel.PresentableSheets>) -> some View {
                switch self {
                case .characterListSheet(let episodeId):
                    CharacterListSheetView(episodeId: episodeId)
                }
            }
        }
    }
}

