//
//  ProductListViewModelTests.swift
//  ProductCatalogTests
//
//  Created by Pradeep Kumar on 26/12/24.
//
//  Author:
//  Pradeep Kumar
//

import XCTest
import Combine
@testable import ProductCatalog

final class ProductListViewModelTests: XCTestCase {
    
    var viewModel: ProductListViewModel!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockNetworkManager = MockNetworkManager()
        viewModel = ProductListViewModel(networkManager: mockNetworkManager)
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockNetworkManager = nil
        cancellables = nil
    }
    
    // 1. Test Initial State
    func testInitialState() {
        // Verify that the view state is set to .idle initially
        XCTAssertEqual(viewModel.viewState, .idle, "The viewState should be .idle initially.")
        // Verify that the product list is empty initially
        XCTAssertTrue(viewModel.productList.isEmpty, "The productList should be empty initially.")
    }
    
    func testFetchCartProductDetailsWithTimeoutError() {
        // Set up mock error (timeout)
        mockNetworkManager.shouldFail = true
        mockNetworkManager.error = URLError(.timedOut)
        
        let expectation = self.expectation(description: "Fetch products timeout error")
        
        // Start fetch
        viewModel.fetchCartProductDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Match the basic error message, ignoring the specific error code
            if case .error(let errorMessage) = self.viewModel.viewState {
                XCTAssertTrue(errorMessage.contains("The operation couldn’t be completed."))
            } else {
                XCTFail("Expected error state but got a different viewState.")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // 2. Test Successful Fetch of Products
    func testFetchCartProductDetailsSuccess() {
        let mockData: ProductMockDataProtocol = ProductMockData()
        
        // Encode the products into mockData
        mockNetworkManager.mockData = try? JSONEncoder().encode(mockData.generateMockProducts(from: MockDataKeys.mockProductsFileName))
        mockNetworkManager.shouldFail = false  // Ensure no failure
        
        // Create an expectation to wait for the async operation
        let expectation = self.expectation(description: "Fetch products")
        viewModel.fetchCartProductDetails()
        viewModel.$viewState
            .dropFirst()  // To ignore the initial loading state
            .sink { state in
                if case .success = state {
                    XCTAssertEqual(state, .success, "View state should be .success after fetching products.")
                    XCTAssertEqual(self.viewModel.productList.count, 2, "The product list should contain 2 products.")
                    let productTitles = self.viewModel.productList.map { $0.title }
                    XCTAssertTrue(productTitles.contains("New Product Title"), "The product list should contain 'New Product Title'.")
                    // Fulfill the expectation to indicate that the async operation is complete
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 10.0)  // Increased timeout
    }
    
    // 3. Test Network Failure
    func testFetchCartProductDetailsNetworkFailure() {
        // Setup mock failure
        mockNetworkManager.shouldFail = true  // Simulate failure
        mockNetworkManager.error = URLError(.notConnectedToInternet) // Set the specific error
        
        let expectation = self.expectation(description: "Fetch products failure")
        
        // Start fetching cart product details
        viewModel.fetchCartProductDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Check that the view state is updated to error with the expected message
            if case .error(let errorMessage) = self.viewModel.viewState {
                XCTAssertEqual(errorMessage, "No internet connection.")
            } else {
                XCTFail("Expected error state but got a different viewState.")
            }
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchCartProductDetailsWithEmptyList() {
        let mockData: ProductMockDataProtocol = ProductMockData()
        // Load empty product list from JSON file
        mockNetworkManager.mockData = try? JSONEncoder().encode(mockData.generateMockProducts(from: MockDataKeys.mockEmptyProductsFileName))
        mockNetworkManager.shouldFail = false
        
        let expectation = self.expectation(description: "Fetch empty product list")
        viewModel.fetchCartProductDetails()
        
        viewModel.$viewState
            .sink { state in
                if case .success = state {
                    XCTAssertEqual(self.viewModel.productList.count, 0, "The product list should be empty.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0)
    }
    
    func testRetryFetchAfterFailure() {
        // Simulate network failure
        mockNetworkManager.shouldFail = true
        mockNetworkManager.error = URLError(.notConnectedToInternet)
        
        let expectation = self.expectation(description: "Fetch products retry")
        viewModel.fetchCartProductDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // First failure
            XCTAssertEqual(self.viewModel.viewState, .error("No internet connection."))
            
            // Trigger retry
            self.viewModel.retryFetch()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // After retry, ensure we handle success or failure as needed
            XCTAssertEqual(self.viewModel.viewState, .error("No internet connection."))
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0)
    }
    
    func testNoProductsAvailableWithRetry() {
        let mockData: ProductMockDataProtocol = ProductMockData()
        // Load empty product list from JSON file
        mockNetworkManager.mockData = try? JSONEncoder().encode(mockData.generateMockProducts(from: MockDataKeys.mockEmptyProductsFileName))
        mockNetworkManager.shouldFail = false
        
        let expectation = self.expectation(description: "No products with retry")
        viewModel.fetchCartProductDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.productList.count, 0, "The product list should be empty.")
            self.viewModel.retryFetch()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.productList.count, 0, "The product list should still be empty after retry.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0)
    }
}
