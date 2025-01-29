//
//  RecipesListViewModel.swift
//  Fetch
//
//  Created by Brady Miller on 1/24/25.
//

import Foundation

class RecipesListViewModel: ObservableObject {
    enum State: Equatable {
        case initial, loading, empty, error
        case loaded(recipes: [Recipe])
    }
    
    @Published var state: State
    
    var recipesAPI: RecipesAPI
    
    init(initialState: State = .initial, recipesAPI: RecipesAPI = Dependencies.recipesAPI) {
        self.state = initialState
        self.recipesAPI = recipesAPI
    }
    
    @MainActor
    func loadRecipes() async {
        self.state = .loading
        
        do {
            let recipes = try await recipesAPI.getRecipes().recipes
            if recipes.count > 0 {
                self.state = .loaded(recipes: recipes)
            } else {
                self.state = .empty
            }
        } catch {
            self.state = .error
        }
    }
}
