//
//  MockNetworkSession.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
/// A mock implementation of `NetworkSessionProtocol` used for testing network requests.
/// This class simulates both successful and failed network responses, allowing developers
/// to test their code without making actual network calls.
///
//  Author:
//  Pradeep Kumar
//

import Foundation
import Combine

class MockNetworkSession: NetworkSessionProtocol {
    /// Mock data to simulate a successful response.
    var mockData: Data? = nil
    
    /// A flag to simulate network failure.
    var shouldFail = false
    
    /// The error to return when simulating a network failure.
    /// Defaults to `URLError(.badServerResponse)`.
    var error: URLError = URLError(.badServerResponse)
    
    /// Simulates fetching data from a network call.
    ///
    /// - Parameters:
    ///   - url: The URL to fetch data from (ignored in this mock).
    ///   - method: The HTTP method of the request (e.g., GET, POST).
    ///   - headers: Optional headers for the request.
    /// - Returns: A publisher that emits either mock data or an error.
    func sendRequestToServer(from url: URL, method: API.HTTPMethod, headers: [String: String]?) -> AnyPublisher<Data, URLError> {
        if shouldFail {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let data = mockData {
            return Just(data)
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        } else {
            // Return an empty `Data` object if no mock data is provided.
            return Just(Data())
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
    }
}

