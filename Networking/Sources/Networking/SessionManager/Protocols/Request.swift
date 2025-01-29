//
//  Request.swift
//  Networking
//
//  Created by Brady Miller on 1/24/25.
//

import Foundation

public protocol Request {
    associatedtype PayloadType: DictionaryEncodable
    associatedtype ReturnType: Codable
    
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var payload: PayloadType { get set }
    var additionalHeaders: [String: String]? { get set }
    var queryParameters: [URLQueryItem]? { get set }
}
