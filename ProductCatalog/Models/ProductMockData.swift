//
//  ProductMockData.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 28/12/24.
//
//  Description: Implements `ProductMockData` to generate mock product data
//  from a JSON file for testing and development purposes.
//
//  - Conforms to `ProductMockDataProtocol`.
//  - Uses `MockDataLoader` to load JSON data.
//  - Decodes data into an array of `ProductModel` using `JSONDecoder`.
//  - Returns an empty array on error (e.g., file not found or decoding failure).
//
//  Usage:
//      let mockData = ProductMockData()
//      let products = mockData.generateMockProducts(from: "mock_products.json")
//
//
//  Author:
//  Pradeep Kumar
//

import Foundation

// Protocol for generating mock product data
protocol ProductMockDataProtocol {
    func generateMockProducts(from fileName: String) -> [ProductModel]
}

struct ProductMockData: ProductMockDataProtocol {
    func generateMockProducts(from fileName: String) -> [ProductModel] {
        guard let mockData = ProductUtility.loadMockData(from: fileName) else {
            return []  // Return empty if data could not be loaded
        }
        do {
            let products = try JSONDecoder().decode([ProductModel].self, from: mockData)
            return products
        } catch {
            print(error.localizedDescription)
            // Return an empty array in case of decoding failure
            return []
        }
    }
}
