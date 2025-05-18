//
//  CharacterListSheetViewModel.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//  
//

import Foundation
import SwiftUICore

extension CharacterListSheetView {
        
    protocol ViewModelProtocol {
        
        var headerTitle: String {get}

        var subheaderTitle1: String {get}
        var subheaderTitle2: String {get}
        var subheaderTitle3: String {get}

        var emptyEpisodeText: String {get}
        var emptyListText: String {get}

        func characterSelected(coordinator: SheetCoordinator<ViewModel.PresentableSheets>, characterId: Int64)
    }
    
    @Observable
    class ViewModel: ViewModelProtocol {
        
        // MARK: - Public
        
        var headerTitle: String { model.headerTitle }
        
        var subheaderTitle1: String { model.subheaderTitle1}
        var subheaderTitle2: String { model.subheaderTitle2}
        var subheaderTitle3: String { model.subheaderTitle3}

        var emptyEpisodeText: String { model.emptyEpisodeText }
        var emptyListText: String { model.emptyListText }

        // MARK: - Private

        private var model = CharacterListSheetModel()
        
        // MARK: - Public functions
        
        func characterSelected(coordinator: SheetCoordinator<ViewModel.PresentableSheets>, characterId: Int64) {
            Task {
                await coordinator.presentSheet(.characterInfoSheet(characterId: characterId))
            }
        }
        
        // MARK: - Presentable sheets
        
        enum PresentableSheets: Identifiable, SheetEnum {
            
            case characterInfoSheet(characterId: Int64)
            
            var id: String {
                switch self {
                    case .characterInfoSheet: return "characterInfoSheet"
                }
            }
            
            @ViewBuilder
            func view(coordinator: SheetCoordinator<ViewModel.PresentableSheets>) -> some View {
                switch self {
                case .characterInfoSheet(let characterId):
                    CharacterInfoSheetView(characterId: characterId)
                }
            }
        }

    }
}

