//
//  ImageFetching.swift
//  Networking
//
//  Created by Brady Miller on 1/28/25.
//

import SwiftUI

public protocol ImageFetching {
    func fetchImage(url: URL) async throws -> UIImage
}
