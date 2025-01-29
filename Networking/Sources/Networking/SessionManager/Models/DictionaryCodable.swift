//
//  DictionaryCodable.swift
//  Networking
//
//  Created by Brady Miller on 1/24/25.
//

import Foundation

public protocol DictionaryCodable: DictionaryEncodable & DictionaryDecodable {}
public protocol DictionaryEncodable: Encodable {}

public extension DictionaryEncodable {
    func dictionary() -> [String: Any]? {
        let encoder = SessionManager.encoder
        guard let json = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
                return nil
        }
        return dict
    }
}

extension Array: DictionaryEncodable where Element: DictionaryEncodable {}

public protocol DictionaryDecodable { }
