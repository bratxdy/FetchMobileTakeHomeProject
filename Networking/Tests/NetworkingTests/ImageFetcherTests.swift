//
//  ImageFetcherTests.swift
//  Networking
//
//  Created by Brady Miller on 1/28/25.
//

import SwiftUI
import Testing

@testable import Networking

class MockSessionManager: SessionManaging {
    var returnUiImage = true
    var fetchCount = 0
    
    func fetch<R>(_ request: R) async throws -> R.ReturnType where R: Request {
        do {
            let data = Data()
            return try SessionManager.decoder.decode(R.ReturnType.self, from: data)
        } catch {
            throw ApiError.jsonConversionFailure(description: error.localizedDescription)
        }
    }
    
    func fetch(from urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        fetchCount += 1
        
        if returnUiImage {
            let uiImage = UIImage(systemName: "exclamationmark.circle")
            return (uiImage!.pngData()!, HTTPURLResponse())
        } else {
            return ("Hello, World!".data(using: .utf8)!, HTTPURLResponse())
        }
    }
}

class MockCache: Cachable {
    var isCached = false
    var storeCount = 0
    
    func cachedImage(for request: URLRequest) -> UIImage? {
        if isCached {
            return UIImage(systemName: "exclamationmark.circle")
        } else {
            return nil
        }
    }
    
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        storeCount += 1
    }
}

struct ImageFetcherTests {
    @Test func testFetchImage_cached() async throws {
        let sessionManager = MockSessionManager()
        let cache = MockCache()
        cache.isCached = true
        let imageFetcher = ImageFetcher(sessionManager: sessionManager, imageCache: cache)
        await #expect(throws: Never.self) {
            let image = try await imageFetcher.fetchImage(url: URL(string: "www.google.com")!)
            #expect(image == UIImage(systemName: "exclamationmark.circle"))
        }
        #expect(sessionManager.fetchCount == 0)
        #expect(cache.storeCount == 0)
    }
    
    @Test func testFetchImage_notCached() async throws {
        let sessionManager = MockSessionManager()
        let cache = MockCache()
        let imageFetcher = ImageFetcher(sessionManager: sessionManager, imageCache: cache)
        await #expect(throws: Never.self) {
            let _ = try await imageFetcher.fetchImage(url: URL(string: "www.google.com")!)
        }
        #expect(sessionManager.fetchCount == 1)
        #expect(cache.storeCount == 1)
    }
    
    @Test func testFetchImage_notImage() async throws {
        let sessionManager = MockSessionManager()
        sessionManager.returnUiImage = false
        let cache = MockCache()
        let imageFetcher = ImageFetcher(sessionManager: sessionManager, imageCache: cache)
        await #expect(throws: ImageError.self) {
            let _ = try await imageFetcher.fetchImage(url: URL(string: "www.google.com")!)
        }
        #expect(sessionManager.fetchCount == 1)
        #expect(cache.storeCount == 0)
    }
}
