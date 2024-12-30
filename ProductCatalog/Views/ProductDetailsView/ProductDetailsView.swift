//
//  ProductDetailsView.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
//  This view is responsible for displaying detailed information about products in the catalog.
//  It interacts with the ProductListViewModel to fetch and manage product data, displaying the UI
//  based on different states such as loading, success, error, and retryable network issues.
//
//  Key Components:
//  - **ViewModel**: Manages the state (loading, success, error, retry) and fetches product details.
//  - **View States**:
//    - **loading**: Displays a custom loading view when fetching data.
//    - **success**: Shows the product list after successful data retrieval.
//    - **error**: Displays an error message when fetching data fails.
//    - **idle**: Represents an idle state before fetching begins.
//  - **Alert Handling**: Displays an alert when there's an error with the data fetching process.
//  - **Preview**: Uses mock data to simulate different view states for UI testing and debugging.
//
//  Author:
//  Pradeep Kumar
//

import SwiftUI
import Network

// MARK: - Main View for Displaying Product Details

struct ProductDetailsView: View {
    
    // ViewModel that manages the state and fetches product data
    @StateObject private var viewModel = ProductListViewModel()
    
    var body: some View {
        VStack {
            // Handle different view states
            switch viewModel.viewState {
            case .loading:
                CustomLoadingView(message: UI.fetchingItems)
            case .success:
                ProductListView(viewModel: viewModel)
            case .error:
                ErrorMessageView(message: AppError.dataLoadFailure.localizedDescription, viewModel: viewModel)
            case .idle:
                Text("Idle State")
            }
        }
        .onAppear {
            // Fetch only if not already loaded or loading
            if viewModel.viewState == .idle  {
                viewModel.fetchCartProductDetails()
            }
        }
        .alert(isPresented: .constant(viewModel.viewState == .error(""))) {
            if case .error(let message) = viewModel.viewState {
                return Alert(title: Text(UI.genericErrorTitle), message: Text(message), dismissButton: .default(Text(UI.okButton)))
            }
            return Alert(title: Text(AppError.unknown.localizedDescription))
        }
    }
}

// MARK: - Preview for UI Testing and Debugging
#Preview {
    // Set up a mock ViewModel with the mock product data
    let mockViewModel = ProductListViewModel()
    let mockData: ProductMockDataProtocol = ProductMockData()
    mockViewModel.productList = mockData.generateMockProducts() // Mock data for testing
    mockViewModel.viewState = .success // Simulate a successful data fetch state
    return ProductDetailsView().environmentObject(mockViewModel)
}
