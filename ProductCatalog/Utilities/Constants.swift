//
//  Constants.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
//  Description:
//  Defines constants and enums used across the application, including API configurations,
//  error handling, UI strings, mock data keys, and view state management.
//
//  Author:
//  Pradeep Kumar
//

import Foundation

// MARK: - API Configuration
/// Stores API-related constants, including base URL, timeout interval, and default headers.

struct API {
    static let baseURL = "https://fakestoreapi.com/products"
    static let timeoutInterval: TimeInterval = 60.0
    static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "Authorization": "Bearer - Need PassToke If have"
    ]
    
    enum HTTPMethod: String {
        case GET, POST, PUT, DELETE
        var value: String { return self.rawValue }
    }
}

// MARK: - Error Handling
/// Defines common errors and their user-friendly descriptions.
///
enum AppError: Error {
    case noInternet
    case requestTimedOut
    case dataLoadFailure
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .noInternet: return "No internet connection."
        case .requestTimedOut: return "The operation couldn’t be completed. (timed out)"
        case .dataLoadFailure: return "Failed to load data. Please try again later."
        case .unknown: return "An unknown error occurred."
        }
    }
}

// MARK: - UI Constants
/// Stores localized UI strings for consistent user messages.
///
struct UI {
    static let fetchingItems = NSLocalizedString("Fetching items...", comment: "UI message when data is loading")
    static let retryButton = NSLocalizedString("Retry", comment: "Retry button text")
    static let okButton = NSLocalizedString("OK", comment: "OK button text")
    static let navigationBarTitle = NSLocalizedString("Product Catalog", comment: "Navigation bar title")
    static let genericErrorTitle = NSLocalizedString("Error", comment: "Geric Error Message")
}

// MARK: - Mock Data Keys
/// Stores file names for mock data used in testing and development.
///
struct MockDataKeys {
    static let mockProductsFileName = "MockProducts"
    static let mockEmptyProductsFileName = "MockEmptyProducts"
}

// MARK: - View State
/// Represents the state of a view, including idle, loading, success, or error.
///
enum CustomViewState: Equatable {
    case idle
    case loading
    case success
    case error(String)
    
    var errorMessage: String? {
        switch self {
        case .error(let message): return message
        default: return nil
        }
    }
}
