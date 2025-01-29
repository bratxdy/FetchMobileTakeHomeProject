//
//  Recipe.swift
//  Fetch
//
//  Created by Brady Miller on 1/24/25.
//

import Foundation

struct Recipe: Codable, Identifiable, Equatable {
    let cuisine: String
    let name: String
    var photoUrlLarge: String?
    var photoUrlSmall: String?
    let uuid: String
    var sourceUrl: String?
    var youtubeUrl: String?
    
    var id: String { return uuid }
}
