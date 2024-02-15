//
//  BookSearchDatasource.swift
//  PlotLuck
//
//  Created by Stephen Walsh on 14/02/2024.
//

import Foundation

protocol BookSearchDatasource {
    typealias Default = GoogleBooksDataSource
    func fetch(for searchTerm: String) async throws -> [BookSearchResult]
}

struct GoogleBooksDataSource: BookSearchDatasource {
    let network: NetworkInterface
    let urlBuilder: URLBuilder
    
    func fetch(for searchTerm: String) async throws -> [BookSearchResult] {
        let url = try urlBuilder.buildBookSearchURL(for: searchTerm)
        let urlRequest = URLRequest(url: url)
        let result: GoogleBookSearchResponse = try await network.fetchData(with: urlRequest)
        
        // Filter out items that do not have at least one author, industry identifier, and a title
        let filteredItems = result.items.filter { item in
            guard let title = item.volumeInfo.title, !title.isEmpty,
                  let authors = item.volumeInfo.authors, !authors.isEmpty,
                  let identifiers = item.volumeInfo.industryIdentifiers, !identifiers.isEmpty else {
                return false
            }
            return true
        }
        
        return filteredItems.map {
            BookSearchResult(
                author: $0.volumeInfo.authors?.joined(separator: ", ") ?? "",
                title: $0.volumeInfo.title ?? "",
                isbn: $0.volumeInfo.industryIdentifiers?.first?.identifier ?? ""
            )
        }
    }
}
