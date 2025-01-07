//
//  NetworkManagerTest.swift
//  ProductCatalogTests
//
//  Created by Pradeep Kumar on 27/12/24.
//

import XCTest
import Combine
@testable import ProductCatalog

final class NetworkManagerTests: XCTestCase {
    
    private var mockSession: MockNetworkSession!
    private var networkManager: NetworkManager!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockSession = MockNetworkSession()
        networkManager = NetworkManager(session: mockSession)
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testFetchProducts_Success() {
        // Arrange: Set up mock products and encoded data
        let mockProducts = [
            ProductModelItems(id: 1, title: "Title 1", price: 10.0, description: "Description 1", category: "Category 1", image: "Image 1", rating: ProductModelItems.Rating(rate: 4.5, count: 100)),
            ProductModelItems(id: 2, title: "Title 2", price: 20.0, description: "Description 2", category: "Category 2", image: "Image 2", rating: ProductModelItems.Rating(rate: 4.0, count: 150))
        ]
        
        guard let mockData = try? JSONEncoder().encode(mockProducts) else {
            XCTFail("Failed to encode mock products")
            return
        }
        
        mockSession.mockData = mockData // Provide mock data to simulate a successful response
        let networkManager = NetworkManager(session: mockSession) // Use MockSession
        
        // Act: Trigger fetch and observe the result
        let expectation = XCTestExpectation(description: "Fetch products")
        var receivedProducts: [ProductModelItems]?
        
        networkManager.fetchProductDetails()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but received error: \(error)")
                }
            }, receiveValue: { products in
                receivedProducts = products
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // Assert: Validate fetched products match mock products
        XCTAssertEqual(receivedProducts?.count, mockProducts.count)
        XCTAssertEqual(receivedProducts?.first?.title, mockProducts.first?.title)
        XCTAssertEqual(receivedProducts?.last?.title, mockProducts.last?.title)
    }
    
    func testFetchProducts_Failure() {
        // Arrange: Simulate a network failure
        mockSession.shouldFail = true
        
        // Act: Trigger fetch and observe the error
        let expectation = XCTestExpectation(description: "Fetch products failure")
        var receivedError: Error?
        
        networkManager.fetchProductDetails()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but received success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // Assert: Verify error is received
        XCTAssertNotNil(receivedError, "An error should have been received when the network request fails")
    }
}
