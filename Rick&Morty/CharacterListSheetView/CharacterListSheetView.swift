//
//  CharacterListSheetView.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//
//

import SwiftUI

struct CharacterListSheetView: View {

    @EnvironmentObject
    private var rickAndMortyApiManager: RickAndMortyApiManager

    @StateObject
    private var sheetCoordinator = SheetCoordinator<ViewModel.PresentableSheets>()

    @State
    private var viewModel = ViewModel() as ViewModelProtocol
    
    @FetchRequest
    private var fetchedEpisode: FetchedResults<Episode>
    @FetchRequest
    private var fetchedCharacters: FetchedResults<Character>

    init(episodeId: Int64) {
        self._fetchedEpisode = FetchRequest(sortDescriptors: [],
                                            predicate: NSPredicate(format: "id == %d", episodeId),
                                            animation: .default)
        self._fetchedCharacters = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Character.id, ascending: true)],
                                               predicate: NSPredicate(format: "SUBQUERY(episodes, $episode, $episode.id = %d).@count > 0", episodeId),
                                               animation: .default)
    }
    
    
    var body: some View {
        
#if DEBUG
        Self._printChanges()
#endif
        
        return ZStack {
            
            GeometryReader { geometry in
                ApplicationStyle.Images.transparentResourcesPack
                    .blur(radius: 3)
                    .frame(maxWidth: geometry.size.width)
            }
            
            VStack {
                Spacer()
                    .frame(height: 32)
                
                VStack {
                    Text(viewModel.headerTitle)
                        .font(ApplicationStyle.Fonts.hugeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(ApplicationStyle.Colors.green)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                        .shadow(color: ApplicationStyle.Colors.yellow, radius: 3, x: 0, y: 0)
                }
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                .shadow(color: Color.black, radius: 3, x: 0, y: 0)

                VStack {
                    Text(viewModel.subheaderTitle1)
                        .font(ApplicationStyle.Fonts.text)
                        .fontWeight(.bold)
                        .foregroundStyle(ApplicationStyle.Colors.yellow)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                        .shadow(color: ApplicationStyle.Colors.green, radius: 2, x: 0, y: 0)
                }
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                .shadow(color: Color.black, radius: 3, x: 0, y: 0)

                VStack {
                    Text(viewModel.subheaderTitle2)
                        .font(ApplicationStyle.Fonts.text)
                        .fontWeight(.bold)
                        .foregroundStyle(ApplicationStyle.Colors.yellow)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                        .shadow(color: ApplicationStyle.Colors.green, radius: 2, x: 0, y: 0)
                }
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                .shadow(color: Color.black, radius: 3, x: 0, y: 0)

                if fetchedCharacters.contains(where: { ApplicationStyle.isRickSanchez(name: $0.name) }) {
                    VStack {
                        Text(viewModel.subheaderTitle3)
                            .font(ApplicationStyle.Fonts.text)
                            .fontWeight(.bold)
                            .foregroundStyle(ApplicationStyle.Colors.yellow)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                            .shadow(color: ApplicationStyle.Colors.green, radius: 2, x: 0, y: 0)
                    }
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                    .shadow(color: Color.black, radius: 3, x: 0, y: 0)
                }

                if fetchedEpisode.first == nil {
                    VStack {
                        Spacer()
                        Text(viewModel.emptyEpisodeText)
                            .font(ApplicationStyle.Fonts.title)
                            .foregroundStyle(ApplicationStyle.Colors.green)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                            .shadow(color: ApplicationStyle.Colors.yellow, radius: 3, x: 0, y: 0)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                    .shadow(color: Color.black, radius: 3, x: 0, y: 0)
                }
                
                if fetchedCharacters.count == 0 {
                    VStack {
                        Spacer()
                        Text(viewModel.emptyListText)
                            .font(ApplicationStyle.Fonts.title)
                            .foregroundStyle(ApplicationStyle.Colors.green)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                            .shadow(color: ApplicationStyle.Colors.yellow, radius: 3, x: 0, y: 0)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                    .shadow(color: Color.black, radius: 3, x: 0, y: 0)
               }
                else {
                    List {
                        ForEach(fetchedCharacters) { character in
                            Button {
                                viewModel.characterSelected(coordinator: sheetCoordinator, characterId: character.id)
                            } label: {
                                Text("\(character.name ?? ApplicationStyle.randomItemMissingText())")
                                    .font(ApplicationStyle.Fonts.largeTitle)
                                    .foregroundStyle(ApplicationStyle.Colors.green)
                                    .frame(maxWidth: .infinity)
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                    .shadow(color: ApplicationStyle.Colors.yellow, radius: 2, x: 0, y: 0)
                            }
                            .background(RoundedRectangle(cornerRadius: 12).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        }
                    }
                    .shadow(color: ApplicationStyle.Colors.yellow, radius: 8, x: 0, y: 0)
                    .refreshable {
                        rickAndMortyApiManager.refreshAllCharacters()
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .containerBackground(Color.white.opacity(0), for: .navigation)
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
            .toolbarVisibility(.visible, for: .automatic)
            .sheetCoordinating(coordinator: sheetCoordinator)
        }
    }
}

#Preview {
    CharacterListSheetView(episodeId: 1)
}

