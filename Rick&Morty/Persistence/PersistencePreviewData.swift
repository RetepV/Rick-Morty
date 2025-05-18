//
//  PersistencePreviewData.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//

import Foundation

struct PersistencePreviewData {
    
    struct EpisodePreviewData {
        let id: Int64
        let name: String
        let airDate: String
        let episodeCode: String
        let characters: [String]
        
        var airDateAsDate: Date? {
            
            let formatter = DateFormatter()
            
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "MMMM d, yyyy"
            
            if let date = formatter.date(from: airDate) {
                return date
            }
            return nil
        }
    }

    static var episodes: [EpisodePreviewData] = [
        EpisodePreviewData(id: 1, name: "Pilot", airDate: "December 2, 2013", episodeCode: "S01E01",
                           characters: ["https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2",
                                        "https://rickandmortyapi.com/api/character/183"]),
        EpisodePreviewData(id: 2, name: "Lawnmower Dog", airDate: "2December 9, 2013", episodeCode: "S01E02",
                           characters: ["https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"]),
        EpisodePreviewData(id: 3, name: "Anatomy Park", airDate: "December 16, 2013", episodeCode: "S01E03",
                           characters: ["https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"]),
        EpisodePreviewData(id: 4, name: "M. Night Shaym-Aliens!", airDate: "January 13, 2014", episodeCode: "S01E04",
                           characters: ["https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"]),
        EpisodePreviewData(id: 5, name: "Meeseeks and Destroy", airDate: "January 20, 2014", episodeCode: "S01E05",
                           characters: ["https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"]),
        EpisodePreviewData(id: 6, name: "Rick Potion #9", airDate: "January 27, 2014", episodeCode: "S01E06",
                           characters: ["https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"]),
        EpisodePreviewData(id: 7, name: "Raising Gazorpazorp", airDate: "March 10, 2014", episodeCode: "S01E07",
                           characters: ["https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"]),
        EpisodePreviewData(id: 8, name: "Rixty Minutes", airDate: "March 17, 2014", episodeCode: "S01E08",
                           characters: ["https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"]),
        EpisodePreviewData(id: 9, name: "Something Ricked This Way Comes", airDate: "March 24, 2014", episodeCode: "S01E09",
                           characters: ["https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"]),
        EpisodePreviewData(id: 10, name: "Close Rick-counters of the Rick Kind", airDate: "April 7, 2014", episodeCode:"S01E10",
                           characters: ["https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"]),
    ]
}
