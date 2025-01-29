//
//  FetchRecipesRequest.swift
//  Fetch
//
//  Created by Brady Miller on 1/28/25.
//

import Foundation
import Networking

class FetchRecipesRequest: Request {
    typealias PayloadType = EmptyPayload
    typealias ReturnType = Recipes
    
    var path: String = "/recipes.json"
    var payload = EmptyPayload()
    var httpMethod: HttpMethod = .get
    var additionalHeaders: [String: String]? = nil
    var queryParameters: [URLQueryItem]? = nil
}
