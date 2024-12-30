//
//  RetryButtonView.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
//  This view represents a retry button. It is used to trigger an action
//  (usually a network request or error recovery) when the user presses it.
//
//  Key Features:
//  - Custom button with a gradient background and bold text.
//  - The action handler allows flexibility for the button's behavior.
//  - Horizontal padding for better tap area and layout consistency.
//
//  Author:
//  Pradeep Kumar
//

import SwiftUI

struct RetryButtonView: View {
    // Action closure that is executed when the button is tapped
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(UI.retryButton)
                .font(.title3)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    RetryButtonView(action: {})
}
