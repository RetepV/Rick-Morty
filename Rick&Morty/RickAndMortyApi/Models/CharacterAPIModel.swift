//
//  CharacterAPIModel.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 17-05-2025.
//

import Foundation

struct CharacterAPIModel: Codable {
    
    struct Origin: Codable {
        let name: String?
        let url: String?
    }
    
    let id: Int64
    let name: String?
    let status: String?
    let species: String?
    let origin: Origin?
    let imageUrl: String?
    let episodeUrls: [String]?
    
    func episodeCount() -> Int {
        episodeUrls?.count ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case origin
        case imageUrl = "image"
        case episodeUrls = "episode"
    }
}
