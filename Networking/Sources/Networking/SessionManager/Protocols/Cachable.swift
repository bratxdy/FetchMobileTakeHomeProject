//
//  Cachable.swift
//  Networking
//
//  Created by Brady Miller on 1/28/25.
//

import UIKit

public protocol Cachable {
    func cachedImage(for request: URLRequest) -> UIImage?
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest)
}
