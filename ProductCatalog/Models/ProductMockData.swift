//
//  ProductMockData.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 28/12/24.
//

import Foundation

// Function to generate mock products
protocol ProductMockDataProtocol {
    func generateMockProducts() -> [Product]
}

struct ProductMockData: ProductMockDataProtocol {
    func generateMockProducts() -> [Product] {
        return [
            Product(
                id: 1,
                title: "Mens Casual Premium Slim Fit T-Shirts",
                price: 22.3,
                description: "Slim-fitting style, contrast raglan long sleeve, three-button henley placket...",
                category: "men's clothing",
                image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
                rating: Product.Rating(rate: 4.1, count: 259)
            ),
            Product(
                id: 2,
                title: "Solid Gold Chain",
                price: 99.9,
                description: "High-quality gold chain for men. Elegant and stylish design...",
                category: "jewelry",
                image: "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UX679_.jpg",
                rating: Product.Rating(rate: 4.8, count: 150)
            )
        ]
    }
}
