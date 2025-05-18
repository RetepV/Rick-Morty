//
//  CharacterInfoStringBuilder.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 17-05-2025.
//

import Foundation

struct CharacterInfoStringBuilder {

    func build(character: Character) -> String {
        
        var infoString: String = ""
        
        // Returns [_the species_] [whatever]
        let species = returnSpecies(species: character.species)
        // Returns [_the name_] [random "Wotsitsname"]
        let name = returnName(name: character.name)
        // Returns [_the origin_] [random "who knows where"]
        let origin = returnOrigin(origin: character.origin?.name)
        // Returns [_count_ episodes] ["1 episode"] ["at least this episode"]
        let episodeCount = returnEpisodeCount(count: character.episodes?.count)
        // Returns [funny dead or alive string].
        let deadOrAlive = returnDeadOrAlive(status: character.status, species: species)

        if ApplicationStyle.isRickSanchez(name: character.name) {
            infoString.append("Oooh, what a handsome Rick! This is the best Rick ever! As Rick as can be! A Rick like no other!\n\nIntroducing... \(name)!\n\n")
            infoString.append("He's a \(species). ")
            if let status = character.status, status.count > 0 {
                infoString.append("Also, he's very much \(status.lowercased()). " )
            }
            else {
                infoString.append("He might be visiting Schroedinger's cat. " )
            }
            infoString.append("He's from \(origin). ")
            infoString.append("Aaaaand he was in \(episodeCount).")
        }
        else {
            
            infoString.append(ApplicationStyle.randomHey())
            
            infoString.append(", this is ")
            
            infoString.append("\(returnAOrAn(word: species)) \(species) ")
            
            infoString.append("called \(name), ")
            
            infoString.append("coming from \(origin). ")
            
            infoString.append("We met in \(episodeCount). ")
            
            infoString.append(deadOrAlive)
        }
        
        return infoString
    }
    
    func returnAOrAn(word: String) -> String {
        if word.ranges(of: /^[aeiouAEIOU].*/).count > 0 {
            return "an"
        }
        else {
            return "a"
        }
    }
    
    // Returns [dead] [alive] []
    func returnDeadOrAlive(status: String?, species: String?) -> String {
        
        let unknowns: [String] = ["And if it's not dead, it's not alive either.", "And it isn't alive, but neither is it dead.", "Aaaand... is it Schroedingers \(species ?? "...thing")?", "It's species has invented a state that is not dead nor alive." ]
        let alives: [String] = ["Unfortunately, it's still alive.", "It's... Alive and kickiiiiiin!", "It's alive.", "Alive, it is.", "Quite alive and dangerous.", "Life has it in it's grips.", "It's still busy postponing it's death.", "Dead, it ain't. Still kicking." ]
        let deads: [String] = ["Aaaand... It's dead.", "It's ded, d-e-d ded", "It's quite dead.", "It's dead. As in neither alive, nor undead", "It's dead, Jim, but not as we know it.", "I'd be buggered if it ain't dead.", "Death has become it.", "It is in a better place now.", "It has succumbed to living." ]

        guard let status else {
            return unknowns[Int.random(in: 0..<unknowns.count)]
        }
        
        if status.lowercased() == "alive" {
            return alives[Int.random(in: 0..<alives.count)]
        }
        else if status.lowercased() == "dead" {
            return deads[Int.random(in: 0..<deads.count)]
        }
        else {
            return unknowns[Int.random(in: 0..<unknowns.count)]
        }
    }
        
    // Returns [_the species_] ["whatever"]
    func returnSpecies(species: String?) -> String {
    
        guard let species else {
            return "Whatever"
        }
        
        if species.lowercased() == "unknown" {
            return "Whatever"
        }
        
        return species
    }
    
    // Returns [_the name_] [random "Wotsitsname"]
    func returnName(name: String?) -> String {
        
        guard let name else {
            return ApplicationStyle.randomWotsItsName()
        }
        
        if name.isEmpty {
            return ApplicationStyle.randomWotsItsName()
        }
        
        return name
    }
    
    // Returns [_the origin_] [random "who knows where"]
    func returnOrigin(origin: String?) -> String {
        
        guard let origin else {
            return ApplicationStyle.randomWhoKnowsWhere()
        }
        
        if origin.isEmpty || origin.lowercased() == "unknown" {
            return ApplicationStyle.randomWhoKnowsWhere()
        }
        
        return origin
    }

    // Returns [_count_ episodes] ["1 episode"] ["at least this episode"]
    func returnEpisodeCount(count: Int?) -> String {

        guard let count else {
            return "at least this episode"
        }
        
        if count == 0 {
            return "at least this episode"
        }
        else if count == 1 {
            return "1 episode"
        }
        else {
            return "\(count) episodes"
        }
    }
}
