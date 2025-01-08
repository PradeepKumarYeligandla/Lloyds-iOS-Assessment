//
//  ProductUtility.swift
//  ProductCatalog
//
//  Created by Pradeep Kumar on 26/12/24.
//
//  Author:
//  Pradeep Kumar
//
//
import Foundation

/// Utility class to load mock data from JSON files in the app bundle.
class ProductUtility {
    /// Loads mock data from a JSON file in the app bundle.
    ///
    /// - Parameter fileName: The name of the JSON file (without `.json` extension).
    /// - Returns: The file's data if found, otherwise `nil`.
    static func loadMockData(from fileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return data
        } catch {
            return nil
        }
    }
}
