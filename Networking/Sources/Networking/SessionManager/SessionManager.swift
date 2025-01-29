//
//  SessionManager.swift
//  Networking
//
//  Created by Brady Miller on 1/24/25.
//

import Foundation

public class SessionManager: SessionManaging {
    public static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    
    public static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    let session: Session
    let urlRequestBuilder: UrlRequestBuilder
    
    public init(session: Session, urlRequestBuilder: UrlRequestBuilder) {
        self.session = session
        self.urlRequestBuilder = urlRequestBuilder
    }
    
    public func fetch<R: Request>(_ request: R) async throws -> R.ReturnType {
        let (data, _) = try await fetch(from: urlRequestBuilder.buildURLRequest(from: request))
        
        do {
            return try SessionManager.decoder.decode(R.ReturnType.self, from: data)
        } catch {
            throw ApiError.jsonConversionFailure(description: error.localizedDescription)
        }
    }
    
    public func fetch(from urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await session.data(for: urlRequest, delegate: nil)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw ApiError.requestFailed(description: "Invalid response") }
        
        guard 200..<300 ~= httpResponse.statusCode else { throw ApiError.responseUnsuccessful(description: "Status Code: \(httpResponse.statusCode)") }
        
        return (data, response)
    }
}

