//
//  RecipesListViewModelTests.swift
//  FetchTests
//
//  Created by Brady Miller on 1/28/25.
//

import Networking
import Testing

@testable import Fetch

struct MockRecipesEndpoint: RecipesAPI {
    let returnValue: Recipes?
    func getRecipes() async throws -> Recipes {
        if let returnValue {
            return returnValue
        } else {
            throw ApiError.requestFailed(description: "Failed")
        }
    }
}

struct RecipesListViewModelTests {

    @Test func testLoadRecipes_success() async throws {
        let returnValue = Recipes(recipes: RecipesFixture.recipes)
        let viewModel = RecipesListViewModel(recipesAPI: MockRecipesEndpoint(returnValue: returnValue))
        await #expect(throws: Never.self) {
            await viewModel.loadRecipes()
            #expect(viewModel.state == .loaded(recipes: RecipesFixture.recipes))
        }
    }
    
    @Test func testLoadRecipes_empty() async throws {
        let returnValue = Recipes(recipes: [])
        let viewModel = RecipesListViewModel(recipesAPI: MockRecipesEndpoint(returnValue: returnValue))
        await #expect(throws: Never.self) {
            await viewModel.loadRecipes()
            #expect(viewModel.state == .empty)
        }
    }
    
    @Test func testLoadRecipes_failure() async throws {
        let viewModel = RecipesListViewModel(recipesAPI: MockRecipesEndpoint(returnValue: nil))
        await #expect(throws: Never.self) {
            await viewModel.loadRecipes()
            #expect(viewModel.state == .error)
        }
    }
}
