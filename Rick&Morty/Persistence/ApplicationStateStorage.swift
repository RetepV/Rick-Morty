//
//  ApplicationStateStorage.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 17-05-2025.
//

import Foundation
import CoreData


struct ApplicationStateStorage {
    
    // MARK: - Constants
    
    enum UserDefaultsKeys: String {
        case episodesLastUpdated
    }
    
    // MARK: - Public

    static var episodesLastUpdated: Date? {
        return UserDefaults.standard.date(forKey: UserDefaultsKeys.episodesLastUpdated.rawValue)
    }
    
    static func setEpisodesLastUpdated(_ date: Date) {
        UserDefaults.standard.set(date: date, forKey: UserDefaultsKeys.episodesLastUpdated.rawValue)
    }
}

extension UserDefaults {
    
    func set(date: Date, forKey key: String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = dateFormatter.string(from: date)
        
        self.set(dateString, forKey: key)
    }
    
    func date(forKey key: String) -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        if let dateString = self.value(forKey: key) as? String {
            return dateFormatter.date(from: dateString)
        }
        
        return nil
    }
}
