//
//  RecipesListView.swift
//  Fetch
//
//  Created by Brady Miller on 1/24/25.
//

import SwiftUI

struct RecipesListView: View {
    @StateObject var viewModel: RecipesListViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .initial, .loading:
                    makeLoadingState()
                case .loaded(let recipes):
                    makeLoadedState(with: recipes)
                case .empty:
                    makeEmptyState()
                case .error:
                    makeErrorState()
                }
            }
            .navigationTitle(Text("Recipes"))
        }
        .task {
            guard viewModel.state == .initial else { return }
            await viewModel.loadRecipes()
        }
    }
    
    @ViewBuilder func makeLoadingState() -> some View {
        VStack {
            Spacer()
            
            ProgressView()
            
            Spacer()
        }
    }
    
    @ViewBuilder func makeLoadedState(with recipes: [Recipe]) -> some View {
        List {
            ForEach(recipes) { recipe in
                HStack {
                    VStack {
                        Text(recipe.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.body)
                            .fontWeight(.bold)
                            .padding(.top, 8)
                        
                        Text(recipe.cuisine)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.callout)
                            .padding(.bottom, 8)
                    }
                    .padding(.leading, 24)
                    
                    Spacer()
                    
                    CachedAsyncImage(url: URL(string: recipe.photoUrlSmall ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 24)
                }
            }
        }
        .refreshable {
            Task { await viewModel.loadRecipes()}
        }
    }
    
    @ViewBuilder func makeEmptyState() -> some View {
        VStack {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .frame(width: 132, height: 132)
                .padding(.top, 128)
            
            Text("There are no recipes")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 24)
            
            Spacer()
            
            Button {
                Task { await viewModel.loadRecipes() }
            } label: {
                Text("Try Again")
            }
            .padding(.bottom, 48)
        }
    }
    
    @ViewBuilder func makeErrorState() -> some View {
        VStack {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .frame(width: 132, height: 132)
                .padding(.top, 128)
            
            Text("An Error Occurred")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 24)
            
            Spacer()
            
            Button {
                Task { await viewModel.loadRecipes() }
            } label: {
                Text("Try Again")
            }
            .padding(.bottom, 48)
        }
    }
}

#Preview("Loading State") {
    RecipesListView(viewModel: RecipesListViewModel(initialState: .loading))
}

#Preview("Loaded State") {
    RecipesListView(viewModel: RecipesListViewModel(initialState: .loaded(recipes: RecipesFixture.recipes)))
}

#Preview("Empty State") {
    RecipesListView(viewModel: RecipesListViewModel(initialState: .empty))
}

#Preview("Error State") {
    RecipesListView(viewModel: RecipesListViewModel(initialState: .error))
}
