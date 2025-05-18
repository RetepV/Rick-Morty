//
//  EpisodeListModel.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 16-05-2025.
//  
//

import Foundation
import SwiftUI

struct EpisodeListModel {
    
    let headerTitle: String = "Welcome to the club, pal"
    let headerSubtitle: String = "Check out my adventures!"
    
    let emptyListText: String = "The universe is everywhere! Just not here, I guess. Let's sit and wait..."
    
    let endOfListText: String = "That's all. Disappointed? Well, you're not alone."
    
    func lastUpdateText(lastUpdated: Date?) -> String {
        
        if let lastUpdated {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "MMMM d, yyyy "
            let dateString = formatter.string(from: lastUpdated)
            
            formatter.dateFormat = "HH:mm"
            let timeString = formatter.string(from: lastUpdated)
            
            return "(Last time I rinsed was \(dateString) at \(timeString))"
        }

        return "(I don't care. I ain't rinsing.)"
    }
}
