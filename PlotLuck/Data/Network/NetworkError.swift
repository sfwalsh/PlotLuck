//
//  NetworkError.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badURL
    case invalidSearchTerm
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            "An error occurred while accessing the network"
        case .invalidSearchTerm:
            "An error occurred while accessing the network, please try another search term"
        }
    }
}
