//
//  RatingView.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 29/12/24.
//
//  Description:
//  This view displays the product's price and rating in a visually appealing manner.
//  The price is styled with a gradient background, and the rating is shown with a star icon and the number of reviews.
//
//  Key Components:
//  - **Price**: Displayed with a gradient background and shadow for visual emphasis.
//  - **Rating**: Displays the product's rating with a star icon and the number of reviews, styled with a gradient.
//
//  Author:
//  Pradeep Kumar
//

import SwiftUI

struct ProductPriceAndRatingDisplayView: View {
    
    // Product price, rating, and rating count passed to the view
    let price: Double
    let rating: Double
    let ratingCount: Int
    
    // Customizable gradients and styling
    var priceGradient: Gradient = Gradient(colors: [Color.red, Color.purple])
    var ratingIcon: String = "star.fill"
    var iconSize: CGFloat = 20
    var ratingGradient: Gradient = Gradient(colors: [Color.red, Color.purple])
    
    var body: some View {
        HStack {
            // Price View with gradient background
            Text("$\(price, specifier: "%.2f")")
                .font(.system(size: 18, weight: .bold)) // Use a custom font size
                .foregroundColor(.white)
                .padding(.horizontal, 12) // Adjusted horizontal padding
                .padding(.vertical, 2) // Reduced vertical padding
                .padding(2)
                .background(LinearGradient(gradient: priceGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Shadow for depth
            Spacer()
            // Rating View with star icon and count
            HStack(spacing: 4) {
                Image(systemName: ratingIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(LinearGradient(gradient: ratingGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                
                Text("\(rating, specifier: "%.1f") (\(ratingCount))")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            }
        }
    }
}

#Preview {
    ProductPriceAndRatingDisplayView(
        price: 12,
        rating: 2.5,
        ratingCount: 122)
}
