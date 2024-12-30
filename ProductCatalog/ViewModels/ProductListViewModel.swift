//
//  ProductListViewModel.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
///  This file defines the `ProductListViewModel`, which is responsible for managing the app's data layer.
///  It interacts with the `NetworkManager` to retrieve product data from a remote source and handles tasks
///  such as loading state management, error handling, and preloading images for product listings. The view model
///  serves as the intermediary between the UI and the data layer, updating the view based on the network response.
///
///  Key Responsibilities:
///  - Fetching product data from the remote source.
///  - Handling different states: loading, success, error, and idle.
///  - Managing error states and providing user-friendly error messages.
///  - Caching images for improved performance when displaying product lists.
//
//  Author:
//  Pradeep Kumar
//

import Foundation
import Combine
import Network
import UIKit

class ProductListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var viewState: CustomViewState = .idle
    @Published var productList: [Product] = []
    @Published var isInternetAvailable = true
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Initializer
    /// Initializes the view model with default or injected dependencies.
    /// - Parameters:
    ///   - networkManager: The network manager used to fetch products.
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: - Public Methods
    /// Fetches product details from the network and preloads their images.
    func fetchCartProductDetails() {
        guard viewState == .idle else { return }
        viewState = .loading
        networkManager.fetchProductDetails()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                   /// self.viewState = .error(error.localizedDescription)
                    self.handleError(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] products in
                self?.productList = products
                self?.viewState = .success
            })
            .store(in: &cancellables)
    }
    
    /// Handles errors that occur during the network request and updates the view state with an appropriate message.
    /// - Parameter error: The error that occurred during the network request.
    private func handleError(_ error: Error) {
        // Handle different error cases, and update viewState accordingly
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                viewState = .error(AppError.noInternet.localizedDescription)
            case .timedOut:
                viewState = .error(AppError.requestTimedOut.localizedDescription)
            default:
                viewState = .error(AppError.unknown.localizedDescription)
            }
        } else {
            viewState = .error(AppError.unknown.localizedDescription)
        }
    }
    /// Retries fetching product details by resetting the view state.
    func retryFetch() {
        viewState = .idle
        fetchCartProductDetails() // Call the fetch method again
    }
}

