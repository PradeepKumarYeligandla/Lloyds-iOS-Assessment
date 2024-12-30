//
//  ErrorMessageView.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
//  This view is displayed when there is an error in loading the product data.
//  It shows an error icon, a message, and a retry button to allow the user
//  to attempt re-fetching the data.
//
//  Key Features:
//  - Displays an error icon to visually indicate an issue.
//  - Shows the error message in a user-friendly way.
//  - Provides a retry button that triggers an action to recover from the error.
//
//  Author:
//  Pradeep Kumar
//

import SwiftUI

struct ErrorMessageView: View {
    let message: String
    @ObservedObject var viewModel: ProductListViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            // Error Icon
            Image(systemName: "xmark.octagon.fill")
                .foregroundColor(.white)
                .font(.system(size: 40))
                .padding(.top, 10)
            
            // Error Message
            Text(message)
                .font(.title2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            // Retry Button to allow the user to try again
            RetryButtonView(action: {
                viewModel.retryFetch()
            })
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .shadow(radius: 15)
        .padding(15)
    }
}

#Preview {
    let mockViewModel = ProductListViewModel()
    return ErrorMessageView(message: AppError.dataLoadFailure.localizedDescription, viewModel: mockViewModel)
}


