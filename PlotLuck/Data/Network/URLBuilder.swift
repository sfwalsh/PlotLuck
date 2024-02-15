//
//  URLBuilder.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 15/02/2024.
//

import Foundation

protocol URLBuilder {
    func buildBookSearchURL(for searchTerm: String) throws -> URL
}

struct GoogleBooksURLBuilder: URLBuilder {
    private let baseURLString: String
    private let apiKey: String
    
    init(
        baseURLString: String = "https://www.googleapis.com/books/v1/",
        apiKey: String
    ) {
        self.baseURLString = baseURLString
        self.apiKey = apiKey
    }
    
    func buildBookSearchURL(for searchTerm: String) throws -> URL {
        guard let url = URL(string: baseURLString),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.badURL
        }
        
        guard let cleanedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw NetworkError.invalidSearchTerm
        }
        
        // Append path component
        components.path += "volumes"
        
        // Add query parameters
        components.queryItems = [
            URLQueryItem(name: "q", value: cleanedSearchTerm),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        return url
    }
}
