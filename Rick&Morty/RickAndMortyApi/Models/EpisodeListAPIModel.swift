//
//  EpisodeListAPIModel.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//

import Foundation

struct EpisodeListAPIModel: Codable {
    
    struct Info: Codable {
        
        let count: Int64?
        let pages: Int64?
        let nextFetchURL: String?
        let prevFetchURL: String?
        
        enum CodingKeys: String, CodingKey {
            case count = "count"
            case pages = "pages"
            case nextFetchURL = "next"
            case prevFetchURL = "prev"
        }
    }
        
    let info: Info?
    let results: [EpisodeAPIModel]?
}
