//
//  Product.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//

import Foundation

// MARK: - Product Model
struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating

    struct Rating: Codable {
        let rate: Double
        let count: Int
    }
}
// Mock Product Data
extension Product {
    static func mockProduct(id: Int = 1, image: String = "https://via.placeholder.com/200") -> Product {
        return Product(
            id: id,
            title: "Sample Product",
            price: 19.99,
            description: "This is a sample product description.",
            category: "Sample Category",
            image: image,
            rating: Product.Rating(rate: 4.5, count: 100)
        )
    }
}

