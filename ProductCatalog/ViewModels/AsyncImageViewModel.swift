//
//  AsyncImageViewModel.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 29/12/24.
//
//  ViewModel to manage the loading and caching of images asynchronously for the ProductCatalog app.
//  The ViewModel uses a NetworkManagerProtocol to download images and stores them in an in-memory cache (NSCache) for reuse.
//  It also provides state management for loading images, showing the loading state and fetched image.
//
//  Key Responsibilities:
//  - Handles loading images from a network or cache.
//  - Manages the loading state (isLoading).
//  - Caches images for reuse to reduce unnecessary network calls.
//  - Cancels any previous download task if a new one starts.
//
//
//

import Foundation
import UIKit
import Combine

// MARK: - ViewModel

@MainActor
class AsyncImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManagerProtocol
    private let imageCache = NSCache<NSString, UIImage>()
    private var currentTask: Task<Void, Never>?
    
    // MARK: - Initialiser
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: - Methods
    func loadImage(from urlString: String) async {
        isLoading = true
        defer { isLoading = false }
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        do {
            let downloadedImage = try await networkManager.downloadImage(from: urlString)
            self.imageCache.setObject(downloadedImage, forKey: urlString as NSString)
            self.image = downloadedImage
        } catch {
            self.image = nil
            print("Error loading image: \(error)")
        }
    }
}
