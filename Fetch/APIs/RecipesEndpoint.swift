//
//  RecipesEndpoint.swift
//  Fetch
//
//  Created by Brady Miller on 1/28/25.
//

import Foundation

struct RecipesEndpoint: RecipesAPI {
    var sessionManager = Dependencies.sessionManager
    
    func getRecipes() async throws -> Recipes {
        let request = FetchRecipesRequest()
        return try await sessionManager.fetch(request)
    }
}
