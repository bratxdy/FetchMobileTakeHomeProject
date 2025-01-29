//
//  UrlRequestBuilder.swift
//  Networking
//
//  Created by Brady Miller on 1/28/25.
//

import Foundation

public struct UrlRequestBuilder {
    let baseUrlString: String
    
    public init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }
    
    func buildURLRequest(from request: any Request) -> URLRequest {
        var components = URLComponents(string: baseUrlString)
        components?.path = request.path
        
        var queryItems = [URLQueryItem]()
        if let queryParameters = request.queryParameters {
            queryItems.append(contentsOf: queryParameters)
            components?.queryItems = queryItems
        }
        
        if request.httpMethod == .get, let dictionary = request.payload.dictionary() {
            addDictionary(dictionary, to: &queryItems)
            components?.queryItems = queryItems
        }
        
        guard let url = components?.url else { fatalError("Couldn't create a URL.") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        if request.httpMethod == .post || request.httpMethod == .put || request.httpMethod == .delete {
            urlRequest.httpBody = try? SessionManager.encoder.encode(request.payload)
        }
        
        if let additionalHeaders = request.additionalHeaders {
            additionalHeaders.forEach {
                urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
        
        return urlRequest
    }
    
    func addDictionary(_ dictionary: [String: Any], to queryParams: inout [URLQueryItem]) {
        dictionary.keys.forEach { key in
            if key.contains("[]") {
                if let values = dictionary[key] as? [String] {
                    values.forEach { value in
                        queryParams.append(URLQueryItem(name: key, value: value))
                    }
                } else if let values = dictionary[key] as? [Int] {
                    values.forEach { value in
                        queryParams.append(URLQueryItem(name: key, value: String(value)))
                    }
                } else {
                    fatalError("If you encounter this, your array probably contains something other than a String or Int")
                }
            } else {
                queryParams.append(URLQueryItem(name: key, value: "\(dictionary[key] ?? "")"))
            }
        }
    }
}
