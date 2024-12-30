//
//  AsyncImageView.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 27/12/24.
//
//  Description:
//  This view is responsible for displaying an image asynchronously from a remote URL.
//  It shows a placeholder while the image is loading and an error image if the image fails to load.
//  It provides options for customizing the image's content mode, corner radius, and error handling.
//
//  Key Components:
//  - **Loading Indicator**: Displays a placeholder while the image is being fetched.
//  - **Error Handling**: Shows a fallback error image if the image fails to load.
//  - **Corner Radius**: Optionally rounds the corners of the image.
//  - **Transition**: Adds a smooth fade-in transition when the image loads.
//
//  Author:
//  Pradeep Kumar
//
//
import SwiftUI

struct AsyncImageView: View {
    
    // Local Properties
    let urlString: String
    let placeholder: Image
    let errorImage: Image
    let contentMode: ContentMode
    let cornerRadius: CGFloat
    
    // ViewModel to handle the image loading logic.
    @StateObject private var viewModel = AsyncImageViewModel()
    
    var body: some View {
        ZStack {
            // If the image is successfully loaded, display it.
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .cornerRadius(cornerRadius)
                    .transition(.opacity.animation(.easeInOut))
            } else if viewModel.isLoading {
                // If the image is still loading, show the placeholder.
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .cornerRadius(cornerRadius)
            }
        }
        .onAppear {
            // Trigger image loading when the view appears.
            Task {
                await viewModel.loadImage(from: urlString)
            }
        }
    }
}

#Preview {
    AsyncImageView(
        urlString: "https://example.com/image.png",
        placeholder: Image(systemName: "photo"),
        errorImage: Image(systemName: "exclamationmark.triangle"),
        contentMode: .fill,
        cornerRadius: 12
    )
    .aspectRatio(contentMode: .fit) // Maintain aspect ratio and fit within the available space
    .clipped() // Ensure the image doesn't overflow
    .padding()
}
