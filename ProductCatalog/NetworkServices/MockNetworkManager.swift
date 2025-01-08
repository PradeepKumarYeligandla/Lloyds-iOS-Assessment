//
//  MockNetworkManager.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
/// A mock implementation of `NetworkManagerProtocol` for unit testing purposes.
/// This class allows you to simulate network requests and responses without making real API calls.
///
//  Author:
//  Pradeep Kumar
//

import Foundation
import Combine
import UIKit

class MockNetworkManager: NetworkManagerProtocol {
    
    // Properties
    var mockData: Data?
    var shouldFail = false
    var error: Error? = URLError(.unknown)
    
    // MARK: - Mock Product Details Fetch
    
    /// Simulates fetching product details from an API.
    /// - Returns: A publisher that emits an array of `Product` objects or an error.
    /// 
    func fetchProductDetails() -> AnyPublisher<[ProductModel], Error> {
        if shouldFail {
            return Fail(error: error ?? URLError(.unknown)).eraseToAnyPublisher()
        }
        // Simulate successful response with mock data
        guard let mockData = mockData else {
            return Just([ProductModel]()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        do {
            let products = try JSONDecoder().decode([ProductModel].self, from: mockData)
            return Just(products)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: URLError(.cannotParseResponse)).eraseToAnyPublisher()
        }
    }
    
    // MARK: - Generic Request (Not Implemented for Testing)
    
    /// Simulates a generic network request.
    /// - Note: This method is not implemented for testing purposes. It is left here as a placeholder.
    /// - Returns: `fatalError()` is called to prevent using this method in tests.
    ///
    func executeRequest<T: Decodable>(
        from url: URL,
        method: API.HTTPMethod,
        headers: [String: String]?,
        decoder: JSONDecoder
    ) -> AnyPublisher<T, Error> {
        fatalError("Not implemented for this test")
    }
    
    // MARK: - Async Image Download (Mocking Image Download)
    
    /// Simulates an asynchronous image download.
    /// - Parameter urlString: The URL string of the image.
    /// - Returns: A `UIImage` object.
    /// - Throws: `URLError(.badURL)` for invalid URL or `URLError(.cannotDecodeContentData)` if the data can't be decoded.
    ///
    func downloadImage(from urlString: String) async throws -> UIImage {
        if shouldFail {
            throw error ?? URLError(.badURL)
        }
        guard let data = mockData, let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        return image
    }
}

