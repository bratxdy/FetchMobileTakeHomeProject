//
//  ImageFetcher.swift
//  Networking
//
//  Created by Brady Miller on 1/28/25.
//

import SwiftUI

public struct ImageError: Error {
    public init() { }
}

public class ImageFetcher: ImageFetching {
    let imageCache: Cachable
    let sessionManager: SessionManaging
    
    public init(sessionManager: SessionManaging, imageCache: Cachable) {
        self.sessionManager = sessionManager
        self.imageCache = imageCache
    }
    
    public func fetchImage(url: URL) async throws -> UIImage {
        let urlRequest = URLRequest(url: url)
        
        if let cachedImage = imageCache.cachedImage(for: urlRequest) {
            return cachedImage
        } else {
            let (data, response) = try await sessionManager.fetch(from: urlRequest)
            
            guard let uiImage = UIImage(data: data) else { throw ImageError() }
            
            let cachedResponse = CachedURLResponse(response: response, data: data)
            imageCache.storeCachedResponse(cachedResponse, for: urlRequest)
            
            return uiImage
        }
    }
}
