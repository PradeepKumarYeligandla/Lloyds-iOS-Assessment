//
//  NetworkManager.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//

// MARK: - Network Manager

// This file defines `NetworkManager` which implements `NetworkManagerProtocol`.
// It provides reusable methods for fetching and decoding data from a network and
// fetching images efficiently, supporting dependency injection for flexibility
// and testability.
//
//  Author:
//  Pradeep Kumar
//

import Foundation
import Combine
import UIKit

// MARK: - Interface

/// Defines the interface for network operations, including fetching data and images.
protocol NetworkManagerProtocol {
    /// Fetches and decodes data into a specified `Decodable` type.
    func executeRequest<T: Decodable>(
        from url: URL,
        method:  API.HTTPMethod,
        headers: [String: String]?,
        decoder: JSONDecoder
    ) -> AnyPublisher<T, Error>
    
    func fetchProductDetails() -> AnyPublisher<[ProductModelItems], Error>
    //func downloadImage(from urlString: String) -> AnyPublisher<UIImage, Error>
    func downloadImage(from urlString: String) async throws -> UIImage
}

// MARK: - NetworkManager

/// Handles network operations using a customizable session for fetching data and images.
class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Properties
    
    /// The session used for network operations, supporting dependency injection.
    private let session: NetworkSessionProtocol
    
    // MARK: - Initializer
    
    /// Initializes `NetworkManager` with a session (default: `URLSession.shared`).
    /// - Parameter session: A session conforming to `NetworkSessionProtocol`.
    init(session: NetworkSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Generic Data Fetching
    
    /// Fetches data from a URL and decodes it into a `Decodable` type.
    ///
    /// - Parameters:
    ///   - url: The URL for the API endpoint.
    ///   - method: The HTTP method for the request (default: `.GET`).
    ///   - headers: Optional HTTP headers to include in the request (default: `nil`).
    ///   - decoder: A `JSONDecoder` for parsing the response data (default: `JSONDecoder()`).
    /// - Returns: A publisher that emits the decoded object of type `T` or an error.
    ///
    func executeRequest<T: Decodable>(
        from url: URL,
        method:  API.HTTPMethod = .GET,
        headers: [String: String]? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        return session.sendRequestToServer(from: url, method: method, headers: headers)
            .tryMap { data -> Data in
                guard !data.isEmpty else { throw URLError(.badServerResponse) }
                return data
            }
            .decode(type: T.self, decoder: decoder) // Decode the validated data
            .receive(on: DispatchQueue.main) // Ensure UI updates occur on the main thread
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Products
    
    /// Fetches a list of products from the API.
    /// - Returns: A publisher emitting an array of `Product` objects or an error.
    ///
    
    func fetchProductDetails() -> AnyPublisher<[ProductModelItems], Error> {
        guard let url = URL(string: API.baseURL) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        return executeRequest(from: url)
    }
    
    // MARK: - Download Image

    /// Asynchronously downloads an image from the given URL string.
    /// - Parameter urlString: The URL string of the image.
    /// - Returns: A `UIImage` object.
    /// - Throws: `URLError(.badURL)` for invalid URL or `URLError(.cannotDecodeContentData)` if the data can't be decoded.
    func downloadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        return image
    }
}
