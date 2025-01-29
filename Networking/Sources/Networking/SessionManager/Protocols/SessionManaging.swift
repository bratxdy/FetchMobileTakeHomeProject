//
//  SessionManaging.swift
//  Networking
//
//  Created by Brady Miller on 1/24/25.
//

import Foundation

public protocol SessionManaging {
    func fetch<R: Request>(_ request: R) async throws -> R.ReturnType
    func fetch(from urlRequest: URLRequest) async throws -> (Data, URLResponse)
}
