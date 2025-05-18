//
//  ApplicationStyle.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 18-05-2025.
//

import Foundation
import SwiftUI

struct ApplicationStyle {
    
    struct Fonts {
        static let hugeTitle: Font = Font.custom("Wubba Lubba Dub Dub", size: 48)
        static let largeTitle: Font = Font.custom("Wubba Lubba Dub Dub", size: 32)
        static let title: Font = Font.custom("Wubba Lubba Dub Dub", size: 24)
        static let text: Font = Font.custom("Wubba Lubba Dub Dub", size: 20)
        static let subtext: Font = Font.custom("Wubba Lubba Dub Dub", size: 16)
        
        static let pdfTitle: Font = Font.custom("Wubba Lubba Dub Dub", size: 64)
        static let pdfRegular: Font = Font.custom("Wubba Lubba Dub Dub", size: 48)
    }
    
    struct Colors {
        static let brown = Color("RickMortyColors/brown")
        static let green = Color("RickMortyColors/green")
        static let pink = Color("RickMortyColors/pink")
        static let skin = Color("RickMortyColors/skin")
        static let yellow = Color("RickMortyColors/yellow")
    }
    
    struct Images {
        static let photoFrame = Image("RickMortyForegrounds/rick_morty_photoframe")
        static let rickAndMortyFabric = Image("RickMortyBackgrounds/RickAndMortyFabric")
        static let transparentResourcesPack = Image("RickMortyBackgrounds/TransparentResourcesPack")
    }

    static func randomHey() -> String {
        let heys: [String] = ["Hey", "Wow", "Whooo", "Dang", "Heh", "Yo", "Djeez", "Gosh"]
        let randomIndex = Int.random(in: 0..<heys.count)
        return heys[randomIndex]
    }
    
    static func randomWotsItsName() -> String {
        let heys: [String] = ["Wotsitsname", "...I forgot...", "...what was it?...", "...wait, give me a sec...", "...isn't this...?", "", "John Doe", ""]
        let randomIndex = Int.random(in: 0..<heys.count)
        return heys[randomIndex]
    }
    
    static func randomWhoKnowsWhere() -> String {
        let places: [String] = ["somewhere", "nobody knows", "who knows where", "... uh ...", "watchamacallit", "...wait... maybe I'll remember later"]
        let randomIndex = Int.random(in: 0..<places.count)
        return places[randomIndex]
    }
    
    static func randomItemMissingText() -> String {
        let heys: [String] = ["<beeep>", "<censored>", "<missing>", "<I don't know>", "<uhhhhhh?>", "<what was it...?>", "<do I care?>", "<insert something here>"]
        let randomIndex = Int.random(in: 0..<heys.count)
        return heys[randomIndex]
    }
    
    static func isRickSanchez(name: String?) -> Bool {
        
        guard let name, !name.isEmpty else {
            return false
        }
        
        let containsRick = name.lowercased().contains("rick")
        let containsSanchez = name.lowercased().contains("sanchez")
        
        return containsRick && containsSanchez
    }
}
