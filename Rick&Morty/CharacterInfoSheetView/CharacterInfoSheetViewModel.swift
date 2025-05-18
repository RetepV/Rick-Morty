//
//  CharacterInfoSheetViewModel.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 17-05-2025.
//
//

import Foundation
import SwiftUI

extension CharacterInfoSheetView {
    
    protocol ViewModelProtocol {

        var funGuyText: String {get}
        var noDataText: String {get}
        var somethingWrongText: String {get}

        var shareAsPDFText: String {get}
        var shareAsCSVText: String {get}
        
        func characterInfoString(character: Character?, fallback: String) -> String

        func renderPDFForExport(character: Character?, characterImage: UIImage?) -> URL
        func renderCSVForExport(character: Character?) -> URL
    }
    
    @Observable
    class ViewModel: @preconcurrency ViewModelProtocol {
        
        // MARK: - Constants
        
        let defaultNoCharacterNameName = "character name"
        
        // MARK: - Public properties
        
        var funGuyText: String { model.funGuyText }
        var noDataText: String { model.noDataText }
        var somethingWrongText: String { model.somethingWrongText }

        var shareAsPDFText: String { model.shareAsPDFText }
        var shareAsCSVText: String { model.shareAsCSVText }
        
        // MARK: - Private properties
        
        private var model = CharacterInfoSheetModel()
        
        private var lastHeaderString: String?
        private var lastCharacterInfoString: String?
        
        // MARK: - Public
        
        func characterInfoString(character: Character?, fallback: String) -> String {
            
            guard let character else {
                return fallback
            }
            
            if lastCharacterInfoString == nil {
                lastCharacterInfoString = CharacterInfoStringBuilder().build(character: character)
            }
            
            return lastCharacterInfoString ?? fallback
        }
        
        @MainActor
        func renderPDFForExport(character: Character?, characterImage: UIImage?) -> URL {
            
            let renderer = ImageRenderer(content:
                                            ZStack {
                
                GeometryReader { geometry in
                    ApplicationStyle.Images.rickAndMortyFabric
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 3)
                        .frame(maxWidth: geometry.size.width)
                }
                
                VStack {
                    Spacer()
                        .frame(height: 16)
                    
                    Text(character?.name ?? ApplicationStyle.randomWotsItsName())
                        .font(ApplicationStyle.Fonts.pdfTitle)
                        .foregroundStyle(ApplicationStyle.Colors.green)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                        .shadow(color: ApplicationStyle.Colors.yellow, radius: 5, x: 0, y: 0)

                    Spacer()
                        .frame(height: 24)
                    
                    ZStack {
                        if let characterImage {
                            Image(uiImage: characterImage)
                                .resizable()
                                .scaledToFit()
                                .padding(EdgeInsets(top: 0, leading: 24, bottom: 64, trailing: 24))
                        }
                        
                        ApplicationStyle.Images.photoFrame
                            .resizable()
                            .scaledToFit()
                            .shadow(color: Color.black, radius: 8, x: 0, y: 0)
                    }
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 32, trailing: 8))
                    
                    Text(characterInfoString(character: character, fallback: model.pdfSomethingWrongText))
                        .font(ApplicationStyle.Fonts.pdfRegular)
                        .foregroundStyle(ApplicationStyle.Colors.green)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .background(RoundedRectangle(cornerRadius: 8).fill(ApplicationStyle.Colors.brown.opacity(0.8)))
                        .shadow(color: ApplicationStyle.Colors.yellow, radius: 4, x: 0, y: 0)

                }
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
            }
                .frame(width: 800, height: 1600, alignment: .center)
            )
            
            let url = URL.documentsDirectory.appending(path: "\(character?.name ?? defaultNoCharacterNameName).pdf")
            
            renderer.render { size, context in
                
                var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                    return
                }

                pdf.beginPDFPage(nil)

                context(pdf)

                pdf.endPDFPage()
                pdf.closePDF()
            }

            return url
        }
        
        func renderCSVForExport(character: Character?) -> URL {
            
            let url = URL.documentsDirectory.appending(path: "\(character?.name ?? defaultNoCharacterNameName).csv")
            
            var outputString = "name, status, species, origin, episodes\n"
            
            if let character {
                if let name = character.name {
                    outputString.append("\"\(name)\", ")
                }
                else {
                    outputString.append(", ")
                }
                if let status = character.status {
                    outputString.append("\"\(status)\", ")
                }
                else {
                    outputString.append(", ")
                }
                if let species = character.species {
                    outputString.append("\"\(species)\", ")
                }
                else {
                    outputString.append(", ")
                }
                if let origin = character.origin?.name {
                    outputString.append("\"\(origin)\", ")
                }
                else {
                    outputString.append(", ")
                }
                
                if let episodes = character.episodes?.count {
                    outputString.append("\(episodes)")
                }
            }
            else {
                outputString.append(model.csvSomethingWrongText)
            }

            outputString.append("\n")
            
            try? outputString.write(to: url, atomically: true, encoding: .utf8)

            return url
        }
    }
}

