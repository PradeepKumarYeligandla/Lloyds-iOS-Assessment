//
//  CustomLoadingView.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 27/12/24.
//
//  Description:
//  Custom loading view that displays a bouncing cart icon and a message with gradient styling.
//  The view includes a background gradient and supports animations for a dynamic loading indicator.
//
//  Key Components:
//  - **Bouncing Cart Icon**: Uses animation for a gentle bounce effect to indicate loading.
//  - **Gradient Background and Text**: Customizable gradient styling for the background and message text.
//  - **Full-Screen Coverage**: The content is centered within the full screen, ignoring safe areas.
//
//  Author:
//  Pradeep Kumar
//

import SwiftUI

struct CustomLoadingView: View {
    
    // Message to display on the loading screen.
    let message: String
    // State variable to control the animation of the cart icon.
    @State private var animate = false // State for bounce animation
    // Gradient colors for styling
    private let gradient = Gradient(colors: [Color.red, Color.purple])
    
    var body: some View {
        ZStack {
            // Background gradient with improved color tones
            LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Center content
            VStack {
                // Cart icon with animation
                Image(systemName: "cart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .offset(y: animate ? -10 : 0) // Gentle bounce effect
                    .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animate)
                    .onAppear {
                        animate = true // Start bounce animation
                    }
                    .padding(.bottom, 0)
                
                // Text message with improved font and style
                Text(message)
                    .font(.system(size: 22, weight: .medium, design: .rounded)) // Best font choice
                    .foregroundStyle(
                        LinearGradient(
                            gradient: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    ) // Apply gradient to text
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Center content
            
        }
    }
}

#Preview {
    CustomLoadingView(message: UI.fetchingItems)
}
