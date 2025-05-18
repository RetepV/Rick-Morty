//
//  CachedImageStorage.swift
//  Rick&Morty
//
//  Created by Peter de Vroomen on 17-05-2025.
//

import Foundation
import UIKit

// Loosely based on:
//
// Downloading of image and caching with URLCache by Mahi Al Jawad
// https://stackoverflow.com/a/77956449/6405218

struct CachedImageStorage {
    
    static func downloadImage(url: URL) async -> UIImage? {
        
        do {
            if let cachedResponse = URLCache.shared.cachedResponse(for: .init(url: url)) {
                
                return UIImage(data: cachedResponse.data)
            } else {
                
                let (data, response) = try await URLSession.shared.data(from: url)
                
                URLCache.shared.storeCachedResponse(.init(response: response, data: data), for: .init(url: url))
                
                guard let image = UIImage(data: data) else {
                    return nil
                }
                
                return image
            }
        }
        catch {
            return nil
        }
    }
}

