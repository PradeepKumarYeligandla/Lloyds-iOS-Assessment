//
//  ProductListView.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
//  Description:
//  This view displays a list of products fetched from the view model. Each product is shown using the `ProductRowView`, which includes the product's image, title, description, price, and rating.
//  The view supports lazy loading by fetching more products when the last product in the list appears on the screen.
//
//  Key Components:
//  - **NavigationView**: Displays the product list with a navigation bar and title.
//  - **List**: A scrollable list that presents products efficiently using `LazyVStack`.
//  - **Lazy Loading**: Automatically fetches more products when the last product in the list is reached.
//
//  Author:
//  Pradeep Kumar
//

import SwiftUI

// MARK: - Main View for Displaying Product List
struct ProductListView: View {
    
    // The view model that provides data and logic for the product list
    @ObservedObject var viewModel: ProductListViewModel
    
    var body: some View {
        NavigationView {
            List {
                LazyVStack {
                    ForEach(viewModel.productList) { product in
                        ProductRowView(model: product)
                            .onAppear {
                                // Move the logic to a separate function for clarity and better type inference
                                handleOnAppear(for: product)
                            }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .navigationTitle(UI.navigationBarTitle)
            .navigationBarTitleDisplayMode(.large)
            .listStyle(PlainListStyle())
            .padding(.top, 1)
        }
    }
    
    private func handleOnAppear(for product: ProductModel) {
        // Access the last product's id explicitly to avoid expensive computation in the loop
        guard let lastProduct = viewModel.productList.last else { return }
        // Fetch more products when the last product appears
        if product.id == lastProduct.id {
            viewModel.fetchCartProductDetails()
        }
    }
}

// MARK: - Preview for UI Testing and Debugging
#Preview {
    // Create a mock ViewModel for simulating the product list
    let mockViewModel = ProductListViewModel()
    let mockData: ProductMockDataProtocol = ProductMockData()
    mockViewModel.productList = mockData.generateMockProducts(from: MockDataKeys.mockProductsFileName)
    mockViewModel.viewState = .success
    return ProductDetailsStateView()
        .environmentObject(mockViewModel) // Inject mock ViewModel into the environment
}
