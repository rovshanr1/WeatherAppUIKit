//
//  NetworkErrors.swift
//  WeatherAppUIKit
//
//  Created by Rovshan Rasulov on 18.09.25.
//

import Foundation

enum NetworkErrors: LocalizedError {
    case invalidURL
    case decodingError(Error)
    case noInternetConnection
    case misingAPIKey
    case invalidResponse
    case notFound
    case unowned(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Error processing data"
        case .noInternetConnection:
            return "No internet connection"
        case .misingAPIKey:
            return "API key not found"
        case .notFound:
            return "URL session failed"
        case .unowned(let error):
            return error.localizedDescription
        }
    }
}
