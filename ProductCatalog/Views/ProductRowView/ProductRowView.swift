//
//  ProductRowView.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
//  Description:
//  A SwiftUI view that displays the details of a single product in the product catalog. It includes the product image, title, description, price, and rating. The image is either loaded from a cache or asynchronously fetched from a URL. The view features smooth scaling animation on appearance and visually distinct typography for a polished presentation.
//
//  Key Components:
//  - **Product Image**: Loaded from cache or asynchronously using `AsyncImageView`.
//  - **Typography**: Styled text for title and description with custom fonts and weights.
//  - **Price & Rating**: Styled price with a gradient and rating with star icons.
//
//  Author:
//  Pradeep Kumar
//

import SwiftUI

// MARK: - Product Row View for Displaying Product Details
struct ProductRowView: View {
    
    // Properties
    @State private var scale: CGFloat = 0.9
    let model: ProductModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Load image from cache or use AsyncImageView with a placeholder
            productImageView
            // Title and Description
            productDetails
            // Price and Rating display
            ProductPriceAndRatingDisplayView(price: model.price, rating:model.rating.rate, ratingCount: model.rating.count)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        .scaleEffect(scale)
        .onAppear {
            applyScaleAnimation()
        }
        
    }
    // MARK: - Computed Views
    /// Displays the product image either from cache or through an async image loader.
    ///
    private var productImageView: some View {
        return AnyView(
            AsyncImageView(
                urlString: model.image,
                placeholder: Image(systemName: "photo"),
                errorImage: Image(systemName: "exclamationmark.triangle"),
                contentMode: .fill,
                cornerRadius: 12
            )
            .aspectRatio(contentMode: .fit)
            .clipped()
            .padding()
        )
    }
    
    /// Displays the title and description of the product.
    private var productDetails: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(model.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(2)
                .padding(.bottom, 2)
            
            Text(model.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .padding(.bottom, 8)
        }
    }
    
    // MARK: - Animation
    /// Applies a spring animation for the scale effect when the view appears.
    ///
    private func applyScaleAnimation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.2)) {
            scale = 1.0
        }
    }
}

// MARK: - Preview for UI Testing and Debugging
#Preview {
    // Generate mock products
    let mockData: ProductMockDataProtocol = ProductMockData()
    // Return the preview for the first product
    return ProductRowView(model: mockData.generateMockProducts(from: MockDataKeys.mockProductsFileName)[0])
        .padding()
}
