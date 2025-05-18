//
//  EpisodeListItemView.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//  
//

import SwiftUI

struct EpisodeListItemView: View {
    
    let name: String
    let airDate: String
    let episodeCode: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(ApplicationStyle.Fonts.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(ApplicationStyle.Colors.green)
                .shadow(color: ApplicationStyle.Colors.yellow, radius: 2, x: 0, y: 0)
            Text("\(episodeCode) - \(airDate)")
                .font(ApplicationStyle.Fonts.text)
                .foregroundStyle(ApplicationStyle.Colors.skin)
                .shadow(color: ApplicationStyle.Colors.green, radius: 2, x: 0, y: 0)
        }
    }
}

#Preview {
    EpisodeListItemView(name: PersistencePreviewData.episodes[0].name,
                        airDate: PersistencePreviewData.episodes[0].airDate,
                        episodeCode:PersistencePreviewData.episodes[0].episodeCode)
}

