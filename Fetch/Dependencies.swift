//
//  Dependencies.swift
//  Fetch
//
//  Created by Brady Miller on 1/28/25.
//

import Foundation
import Networking

enum Dependencies {
    static let imageCache = ImageCache(cache: Dependencies.urlCache)
    static let imageFetcher = ImageFetcher(sessionManager: Dependencies.sessionManager, imageCache: Dependencies.imageCache)
    static let recipesAPI: RecipesAPI = RecipesEndpoint()
    static let session = URLSession.shared
    static let sessionManager = SessionManager(session: Dependencies.session, urlRequestBuilder: Dependencies.urlRequestBuilder)
    static let urlCache = URLCache(memoryCapacity: 512*1024*1024, diskCapacity: 10*1024*1024*1024)
    static let urlRequestBuilder = UrlRequestBuilder(baseUrlString: "https://d3jbb8n5wk0qxi.cloudfront.net")
}
