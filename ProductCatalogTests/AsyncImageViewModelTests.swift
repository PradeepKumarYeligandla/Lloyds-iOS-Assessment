//
//  AsyncImageViewModelTests.swift
//  ProductCatalogTests
//
//  Created by Pradeep Kumar on 29/12/24.
//
//  Author:
//  Pradeep Kumar
//

import XCTest
import Combine
@testable import ProductCatalog

final class AsyncImageViewModelTests: XCTestCase {
    
    var viewModel: AsyncImageViewModel!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable> = []
    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockNetworkManager = MockNetworkManager()
        viewModel = AsyncImageViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockNetworkManager = nil
        cancellables.removeAll()
    }
    
    func testLoadImageFailure() async throws {
        // Given
        mockNetworkManager.shouldFail = true
        mockNetworkManager.error = URLError(.notConnectedToInternet) // Simulate a network error
        
        // When
        await viewModel.loadImage(from: "https://example.com/image.png")
        
        // Then
        await MainActor.run {
            XCTAssertNil(viewModel.image, "Image should be nil on failure")
            XCTAssertFalse(viewModel.isLoading, "isLoading should be false after failure")
        }
    }
}
