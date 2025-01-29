//
//  Session.swift
//  Networking
//
//  Created by Brady Miller on 1/29/25.
//

import Foundation

public protocol Session {
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: Session { }
