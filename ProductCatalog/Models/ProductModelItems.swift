//
//  Product.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//

import Foundation

// MARK: - Product Model
struct ProductModelItems: Identifiable, Codable {
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
extension ProductModelItems {
    static func mockProduct(id: Int = 1, image: String = "https://via.placeholder.com/200") -> ProductModelItems {
        return ProductModelItems(
            id: id,
            title: "Sample Product",
            price: 19.99,
            description: "This is a sample product description.",
            category: "Sample Category",
            image: image,
            rating: ProductModelItems.Rating(rate: 4.5, count: 100)
        )
    }
}

