//
//  RecipesAPI.swift
//  Fetch
//
//  Created by Brady Miller on 1/28/25.
//

import Foundation

protocol RecipesAPI {
    func getRecipes() async throws -> Recipes
}
