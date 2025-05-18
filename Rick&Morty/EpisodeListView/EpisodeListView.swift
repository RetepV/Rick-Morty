//
//  EpisodeListView.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//
//

import SwiftUI
import CoreData

struct EpisodeListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject
    private var rickAndMortyApiManager: RickAndMortyApiManager

    @State
    var viewModel = ViewModel() as ViewModelProtocol
    @State
    var forceRefreshUIToggler: Bool = false
    
    @StateObject
    var sheetCoordinator = SheetCoordinator<ViewModel.PresentableSheets>()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Episode.id, ascending: true)],
        animation: .default)
    private var fetchedEpisodes: FetchedResults<Episode>
    
    var body: some View {
        
#if DEBUG
        Self._printChanges()
#endif
        
        return ZStack {
            
            if forceRefreshUIToggler { EmptyView() }
            
            GeometryReader { geometry in
                ApplicationStyle.Images.rickAndMortyFabric
                    .blur(radius: 3)
                    .frame(maxWidth: geometry.size.width)
            }
            
            NavigationStack {
                
                VStack {
                    
                    VStack {
                        Text(viewModel.headerTitle)
                            .font(ApplicationStyle.Fonts.hugeTitle)
                            .fontWeight(.regular)
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
                        Text(viewModel.headerSubtitle)
                            .font(ApplicationStyle.Fonts.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(ApplicationStyle.Colors.yellow)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                            .shadow(color: ApplicationStyle.Colors.green, radius: 3, x: 0, y: 0)
                    }
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                    .shadow(color: Color.black, radius: 3, x: 0, y: 0)

                    if fetchedEpisodes.count == 0 {
                        VStack {
                            Spacer()
                            Text(viewModel.emptyListText)
                                .font(ApplicationStyle.Fonts.largeTitle)
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
                            ForEach(fetchedEpisodes, id: \.id) { episode in
                                
                                Button {
                                    viewModel.episodeSelected(coordinator: sheetCoordinator, id: episode.id)
                                } label: {
                                    HStack {
                                        EpisodeListItemView(name: episode.name ?? ApplicationStyle.randomItemMissingText(),
                                                            airDate: episode.formattedAirDate ?? ApplicationStyle.randomItemMissingText(),
                                                            episodeCode: episode.episodeCode ?? ApplicationStyle.randomItemMissingText())
                                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .background(RoundedRectangle(cornerRadius: 12).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))                                
                            }
                            VStack {
                                Text(viewModel.endOfListText)
                                    .font(ApplicationStyle.Fonts.title)
                                    .foregroundStyle(ApplicationStyle.Colors.yellow)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                    .shadow(color: ApplicationStyle.Colors.green, radius: 3, x: 0, y: 0)
                                Text(viewModel.episodesLastUpdated)
                                    .font(ApplicationStyle.Fonts.subtext)
                                    .foregroundStyle(ApplicationStyle.Colors.yellow)
                                    .frame(maxWidth: .infinity)
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                    .shadow(color: ApplicationStyle.Colors.green, radius: 3, x: 0, y: 0)
                            }
                            .background(RoundedRectangle(cornerRadius: 12).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        }
                        .shadow(color: ApplicationStyle.Colors.yellow, radius: 8, x: 0, y: 0)
                        .refreshable {
                            rickAndMortyApiManager.updateEpisodeList {
                                forceRefreshUIToggler.toggle()
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .containerBackground(Color.white.opacity(0), for: .navigation)
                .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
                .toolbarVisibility(.visible, for: .automatic)
            }
            .task {
                rickAndMortyApiManager.updateEpisodeList {
                    // NOTE: During an update, it might be that nothing is actually updated. So we might not have
                    //       any UI refreshes. But the episodesLastUpdated is also updated, and that doesn't trigger
                    //       a UI refresh. So we need to force a refresh after updating.
                    // TODO: This could be fixed in other ways. But low prio.
                    forceRefreshUIToggler.toggle()
                }
            }
            .sheetCoordinating(coordinator: sheetCoordinator)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    EpisodeListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

