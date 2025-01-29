//
//  ImageCache.swift
//  Networking
//
//  Created by Brady Miller on 1/28/25.
//

import UIKit

public class ImageCache: Cachable {
    let cache: URLCache
   
    public init(cache: URLCache) {
        self.cache = cache
    }
    
    public func cachedImage(for request: URLRequest) -> UIImage? {
        guard let cachedResponse = cache.cachedResponse(for: request), let uiImage = UIImage(data: cachedResponse.data) else { return nil }
        return uiImage
    }
    
    public func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        cache.storeCachedResponse(cachedResponse, for: request)
    }
}
