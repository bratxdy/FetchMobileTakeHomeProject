//
//  SessionManagerTests.swift
//  Networking
//
//  Created by Brady Miller on 1/29/25.
//

import Foundation
import Testing

@testable import Networking

class MockSession: Session {
    var statusCode = 200
    var returnHttpResponse = true
    var data = "Hello, World!".data(using: .utf8)!
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        if returnHttpResponse {
            return (data, HTTPURLResponse(url: URL(string: "www.google.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!)
        } else {
            return (data, URLResponse())
        }
    }
}

class TestRequest: Request {
    typealias PayloadType = EmptyPayload
    typealias ReturnType = TestReturnType
    
    var payload = EmptyPayload()
    var path: String = "/path"
    var httpMethod: HttpMethod = .get
    var additionalHeaders: [String: String]? = nil
    var queryParameters: [URLQueryItem]? = nil
}

struct TestReturnType: Codable {
    var value: String
}

struct SessionManagerTests {
    
    @Test func testFetch_success() async throws {
        let jsonData =
        """
        {
            "value": "Hello, World!"
        }
        """.data(using: .utf8)!
        let session = MockSession()
        session.data = jsonData
        let sessionManager = SessionManager(session: session, urlRequestBuilder: UrlRequestBuilder(baseUrlString: "www.google.com"))
        await #expect(throws: Never.self) {
            let ret = try await sessionManager.fetch(TestRequest())
            #expect(ret.value == "Hello, World!")
        }
    }
    
    @Test func testFetch_malformed() async throws {
        let jsonData =
        """
        {
            "value": 5
        }
        """.data(using: .utf8)!
        let session = MockSession()
        session.data = jsonData
        let sessionManager = SessionManager(session: session, urlRequestBuilder: UrlRequestBuilder(baseUrlString: "www.google.com"))
        await #expect(throws: ApiError.jsonConversionFailure(description: "The data couldn’t be read because it isn’t in the correct format.")) {
            let _ = try await sessionManager.fetch(TestRequest())
        }
    }

    @Test func testFetchUrlRequest_success() async throws {
        let session = MockSession()
        let sessionManager = SessionManager(session: session, urlRequestBuilder: UrlRequestBuilder(baseUrlString: "www.google.com"))
        await #expect(throws: Never.self) {
            let (data, response) = try await sessionManager.fetch(from: URLRequest(url: URL(string: "www.google.com")!))
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Issue.record("Not the correct response")
                return
            }
            #expect(httpResponse.statusCode == 200)
            
            let string = String(data: data, encoding: .utf8)
            #expect(string == "Hello, World!")
        }
    }
    
    @Test func testFetchUrlRequest_invalidResponse() async throws {
        let session = MockSession()
        session.returnHttpResponse = false
        let sessionManager = SessionManager(session: session, urlRequestBuilder: UrlRequestBuilder(baseUrlString: "www.google.com"))
        await #expect(throws: ApiError.requestFailed(description: "Invalid response")) {
            let _ = try await sessionManager.fetch(from: URLRequest(url: URL(string: "www.google.com")!))
        }
    }

    @Test func testFetchUrlRequest_notSuccess() async throws {
        let session = MockSession()
        session.statusCode = 401
        let sessionManager = SessionManager(session: session, urlRequestBuilder: UrlRequestBuilder(baseUrlString: "www.google.com"))
        await #expect(throws: ApiError.responseUnsuccessful(description: "Status Code: 401")) {
            let _ = try await sessionManager.fetch(from: URLRequest(url: URL(string: "www.google.com")!))
        }        
    }
}
