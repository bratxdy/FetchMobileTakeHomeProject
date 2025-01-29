//
//  FetchApp.swift
//  Fetch
//
//  Created by Brady Miller on 1/24/25.
//

import SwiftUI

@main
struct FetchApp: App {
    var body: some Scene {
        WindowGroup {
            RecipesListView(viewModel: RecipesListViewModel())
        }
    }
}
