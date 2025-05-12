//
//  DogError.swift
//  dogApp
//
//  Created by eloddobos on 2025-05-12.
//

import Foundation

enum DogError: Error {
    case networkError
    case decodingError
    case invalidURL
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Network error occurred."
        case .decodingError:
            return "Failed to decode data."
        case .invalidURL:
            return "Invalid URL."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
