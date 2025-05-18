//
//  EpisodeAPIModel.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//

import Foundation

struct EpisodeAPIModel: Codable {
    
    let id: Int64
    let name: String?
    let airDate: String?
    let episodeCode: String?
    let characters: [String]?
    
    var airDateAsDate: Date? {
        
        guard let airDate else {
            return nil
        }

        let formatter = DateFormatter()
        
        // There are no specifications for the format of dates. Try a few formats that
        // are known to be returned by the API.
        
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        formatter.dateFormat = "MMMM d, yyyy"
        if let date = formatter.date(from: airDate) {
            return date
        }
        
        formatter.dateFormat = "yyyy-MM-dd’T’HH:mm:ssZ"
        if let date = formatter.date(from: airDate) {
            return date
        }
        
        formatter.dateFormat = "MM/dd/yyyy"
        if let date = formatter.date(from: airDate) {
            return date
        }
        
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episodeCode = "episode"
        case characters
    }
}
