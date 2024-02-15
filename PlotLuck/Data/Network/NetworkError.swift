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
}
