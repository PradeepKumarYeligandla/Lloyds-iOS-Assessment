//
//  ProductModel.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
//  Description:
//  This file defines the `ProductModel` struct, which represents a product in the catalog.
//  It includes properties such as `id`, `title`, `price`, `description`, `category`, `image`,
//  and a nested `Rating` struct to store rating details.
//
//  Key Features:
//  - Conforms to `Identifiable` for use in SwiftUI views.
//  - Conforms to `Codable` for seamless JSON decoding and encoding.
//  - Supports a nested structure (`Rating`) for product ratings.
//
//  Usage:
//  Use `ProductModel` to decode product data from JSON APIs or display product details
//  in SwiftUI or UIKit applications.
//
//
//  Author:
//  Pradeep Kumar
//
//
import Foundation

// MARK: - Product Model
struct ProductModel: Identifiable, Codable {
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
