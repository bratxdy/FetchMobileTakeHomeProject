//
//  RecipesFixture.swift
//  Fetch
//
//  Created by Brady Miller on 1/28/25.
//

import Foundation
import Networking

enum RecipesFixture {
    static var recipes: [Recipe] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try! SessionManager.decoder.decode(Recipes.self, from: LocalJsonParsing().getJsonData(from: "Recipes")).recipes
    }
}
