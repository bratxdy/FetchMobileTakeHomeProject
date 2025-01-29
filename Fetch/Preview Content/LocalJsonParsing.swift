//
//  LocalJsonParsing.swift
//  Fetch
//
//  Created by Brady Miller on 1/28/25.
//

import Foundation

class LocalJsonParsing {
    func getJsonData(from filename: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: filename, ofType: "json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path))
    }
}
