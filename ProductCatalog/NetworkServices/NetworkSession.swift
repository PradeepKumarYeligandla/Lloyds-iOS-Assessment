//
//  NetworkSession.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
// This file defines a protocol for network operations (`NetworkSessionProtocol`)
// and extends `URLSession` to conform to it, enabling seamless integration
// with the `NetworkManager`. The protocol abstraction allows for easier testing
// and flexibility with different session implementations.
//
//  Author:
//  Pradeep Kumar
//

import Foundation
import Combine

// MARK: - NetworkSession Protocol
/// Defines requirements for performing network operations.
/// Enables `NetworkManager` to work with any network session implementation.
///
protocol NetworkSessionProtocol {
    func sendRequestToServer(from url: URL, method: API.HTTPMethod, headers: [String: String]?) -> AnyPublisher<Data, URLError>
}

// MARK: - URLSession Extension
/// Conforms `URLSession` to `NetworkSessionProtocol`, allowing its use in `NetworkManager`.
///
extension URLSession: NetworkSessionProtocol {
    func sendRequestToServer(from url: URL, method: API.HTTPMethod, headers: [String : String]? = nil) -> AnyPublisher<Data, URLError> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addHeaders(headers)
        return dataTaskPublisher(for: request)
            .map { $0.data }
            .receive(on: DispatchQueue.global(qos: .background)) // Perform processing on a background thread.
            .eraseToAnyPublisher()
    }
}

// MARK: - URLRequest Extension
/// Adds headers to a URLRequest.
/// 
extension URLRequest {
    mutating func addHeaders(_ headers: [String: String]?) {
        headers?.forEach { key, value in
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
}
