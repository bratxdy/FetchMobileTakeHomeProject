//
//  ApiError.swift
//  Networking
//
//  Created by Brady Miller on 1/24/25.
//

import Foundation

public enum ApiError: Error, Equatable {
    case requestFailed(description: String)
    case responseUnsuccessful(description: String)
    case jsonConversionFailure(description: String)
    
    var customDescription: String {
        switch self {
        case .requestFailed(let description):
            return "Request Failed: \(description)"
        case .responseUnsuccessful(let description):
            return "Unsuccessful: \(description)"
        case .jsonConversionFailure(let description):
            return "JSON Conversion Failure: \(description)"
        }
    }
}
