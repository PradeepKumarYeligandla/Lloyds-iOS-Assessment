//
//  Constants.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
//  Author:
//  Pradeep Kumar
//

import Foundation

// MARK: - API Configuration
//
///// A struct to store all constants, including API configuration, default headers, and error messages.

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

struct UI {
    static let fetchingItems = NSLocalizedString("Fetching items...", comment: "UI message when data is loading")
    static let retryButton = NSLocalizedString("Retry", comment: "Retry button text")
    static let okButton = NSLocalizedString("OK", comment: "OK button text")
    static let navigationBarTitle = NSLocalizedString("Product Catalog", comment: "Navigation bar title")
    static let genericErrorTitle = NSLocalizedString("Error", comment: "Geric Error Message")
}

// MARK: - View State

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
