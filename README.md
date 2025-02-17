# Lloyds-iOS-Assessment
# ProductCatalog App

The ProductCatalog app is a modern iOS application built using **SwiftUI**, designed to display a list of products fetched from a network API. The app handles multiple states such as loading, success, error, and idle, and it includes several views to display product details, price, and ratings. The app also includes features like lazy loading of products and image caching.

## Features

- **Product Listing**: Displays a list of products, each with an image, title, description, price, and rating.
- **Lazy Loading**: More products are fetched when the last product in the list is displayed.
- **Error Handling**: Displays appropriate error messages when product data cannot be loaded.
- **Image Caching**: Images are cached to prevent re-downloading them when scrolling.
- **Custom Loading State**: Displays a custom loading indicator when the products are being fetched.

## Architecture

The app is structured using the following components:

- **ViewModel**: The `ProductListViewModel` is responsible for managing the state of the product list, fetching product details from the network, and handling error states.
- **Views**: The app has several views:
  - `ProductDetailStateView`: Manages the display of different states (loading, success, error, idle).
  - `ProductListView`: Displays the list of products.
  - `ProductRowView`: Displays each individual product in the list with its details.
  - `ProductPriceAndRatingDisplayView`: Displays the price and rating of the product.
  - `AsyncImageView`: Handles asynchronous image loading and caching.
- **Model**: The app uses a `ProductModel` model to represent each product, which contains essential details such as `id`, `title`, `price`, `description`, `category`, and `rating`. Each product also includes an embedded `Rating` model to hold rating information.
- **Networking**: The `NetworkManager` is responsible for handling network requests to fetch product data and images.

## Requirements

- **iOS 13.0 or later**: Required to support SwiftUI and Combine frameworks, which are extensively used in this app.
- **Swift 5.0 or later**: Ensures compatibility with SwiftUI’s declarative syntax and modern Swift language features.
- **SwiftUI**: The app is fully built using SwiftUI, leveraging its declarative and composable UI architecture.

## Installation

To install and run the project:

1. Clone the repository:
    ```bash
    git clone https://github.com/PradeepKumarYeligandla/Lloyds-iOS-Assessment
    ```
2. Open the project in Xcode:
    ```bash
    open ProductCatalog.xcodeproj
    ```
3. Build and run the app on your simulator or device.

## Usage

When you launch the app, it will attempt to load the product details from the network. The app will display a loading spinner while the data is being fetched. If the fetch is successful, the product list will be displayed. If there is an error, an appropriate error message will be shown.

- **Retry Fetch**: If an error occurs, you can retry fetching the products by tapping the retry button.

## Customization

- You can customize the `ProductRowView`, `ProductPriceAndRatingDisplayView`, and other views to change the appearance of the product listing.
- The app also supports customizing the gradient colors used for the price and rating display.

## Contributing

Feel free to open issues or submit pull requests. Contributions are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### Credits

- The app uses `AsyncImageView` to load and cache images asynchronously.
- The app uses `Combine` for reactive programming and state management.
